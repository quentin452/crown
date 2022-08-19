/*
 * Copyright (c) 2012-2022 Daniele Bartolini et al.
 * License: https://github.com/crownengine/crown/blob/master/LICENSE
 */

#include "core/containers/vector.inl"
#include "core/error/error.h"
#include "core/memory/temp_allocator.inl"
#include "core/os.h"
#include "core/platform.h"
#include "core/strings/dynamic_string.inl"
#include "core/strings/string_stream.h"
#include <string.h>   // strcmp
#include <sys/stat.h> // stat, mkdir

#if CROWN_PLATFORM_WINDOWS
	#include <io.h>       // _access
	#include <stdio.h>
	#ifndef WIN32_LEAN_AND_MEAN
		#define WIN32_LEAN_AND_MEAN
	#endif
	#include <windows.h>
#else
	#include <dirent.h>   // opendir, readdir
	#include <dlfcn.h>    // dlopen, dlclose, dlsym
	#include <errno.h>
	#include <stdio.h>    // fputs
	#include <stdlib.h>   // getenv
	#include <string.h>   // memset
	#include <sys/wait.h> // wait
	#include <time.h>     // clock_gettime
	#include <unistd.h>   // unlink, rmdir, getcwd, access
#endif
#if CROWN_PLATFORM_ANDROID
	#include <android/log.h>
#endif

namespace crown
{
namespace os
{
	void sleep(u32 ms)
	{
#if CROWN_PLATFORM_WINDOWS
		Sleep(ms);
#else
		usleep(ms * 1000);
#endif
	}

	void *library_open(const char *path)
	{
#if CROWN_PLATFORM_WINDOWS
		return (void *)LoadLibraryA(path);
#else
		return ::dlopen(path, RTLD_LAZY);
#endif
	}

	void library_close(void *library)
	{
#if CROWN_PLATFORM_WINDOWS
		FreeLibrary((HMODULE)library);
#else
		dlclose(library);
#endif
	}

	void *library_symbol(void *library, const char *name)
	{
#if CROWN_PLATFORM_WINDOWS
		return (void *)GetProcAddress((HMODULE)library, name);
#else
		return ::dlsym(library, name);
#endif
	}

	void log(const char *msg)
	{
#if CROWN_PLATFORM_ANDROID
		__android_log_write(ANDROID_LOG_DEBUG, "crown", msg);
#else
		fputs(msg, stdout);
		fflush(stdout);
#endif
#if CROWN_PLATFORM_WINDOWS
		OutputDebugStringA(msg);
#endif
	}

#if CROWN_PLATFORM_POSIX
	void stat(Stat &info, int fd)
	{
		info.file_type = Stat::NO_ENTRY;
		info.size = 0;
		info.mtime = 0;

		struct stat buf;
		memset(&buf, 0, sizeof(buf));
		int err = ::fstat(fd, &buf);
		if (err != 0)
			return;

		if (S_ISREG(buf.st_mode) == 1)
			info.file_type = Stat::REGULAR;
		else if (S_ISDIR(buf.st_mode) == 1)
			info.file_type = Stat::DIRECTORY;

		info.size  = buf.st_size;
		info.mtime = buf.st_mtim.tv_sec * s64(1000000000) + buf.st_mtim.tv_nsec;
	}
#endif

	void stat(Stat &info, const char *path)
	{
		info.file_type = Stat::NO_ENTRY;
		info.size  = 0;
		info.mtime = 0;

#if CROWN_PLATFORM_WINDOWS
		WIN32_FIND_DATAA wfd;
		HANDLE fh = FindFirstFileA(path, &wfd);
		if (fh == INVALID_HANDLE_VALUE)
			return;
		FindClose(fh);

		if ((wfd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) != 0)
			info.file_type = Stat::DIRECTORY;
		else // Assume regular file.
			info.file_type = Stat::REGULAR;

		ULARGE_INTEGER large_int = {};

		large_int.LowPart  = wfd.nFileSizeLow;
		large_int.HighPart = wfd.nFileSizeHigh;
		info.size = large_int.QuadPart;

		large_int.LowPart  = wfd.ftLastWriteTime.dwLowDateTime;
		large_int.HighPart = wfd.ftLastWriteTime.dwHighDateTime;
		info.mtime = large_int.QuadPart * u64(100); // See https://docs.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-filetime
#else
		struct stat buf;
		memset(&buf, 0, sizeof(buf));
		int err = ::stat(path, &buf);
		if (err != 0)
			return;

		if (S_ISREG(buf.st_mode) == 1)
			info.file_type = Stat::REGULAR;
		else if (S_ISDIR(buf.st_mode) == 1)
			info.file_type = Stat::DIRECTORY;

		info.size  = buf.st_size;
		info.mtime = buf.st_mtim.tv_sec * s64(1000000000) + buf.st_mtim.tv_nsec;
#endif
	}

	DeleteResult delete_file(const char *path)
	{
		DeleteResult dr;
#if CROWN_PLATFORM_WINDOWS
		if (DeleteFile(path) != 0)
			dr.error = DeleteResult::SUCCESS;
		else if (GetLastError() == ERROR_FILE_NOT_FOUND)
			dr.error = DeleteResult::NO_ENTRY;
		// else if (GetLastError() == ERROR_ACCESS_DENIED)
		// 	dr.error = DeleteResult::NOT_FILE;
		else
			dr.error = DeleteResult::UNKNOWN;
#else
		if (::unlink(path) == 0)
			dr.error = DeleteResult::SUCCESS;
		else if (errno == ENOENT)
			dr.error = DeleteResult::NO_ENTRY;
		else
			dr.error = DeleteResult::UNKNOWN;
#endif
		return dr;
	}

	CreateResult create_directory(const char *path)
	{
		CreateResult cr;
#if CROWN_PLATFORM_WINDOWS
		if (CreateDirectory(path, NULL) != 0)
			cr.error = CreateResult::SUCCESS;
		else if (GetLastError() == ERROR_ALREADY_EXISTS)
			cr.error = CreateResult::ALREADY_EXISTS;
		else
			cr.error = CreateResult::UNKNOWN;
#else
		if (::mkdir(path, 0755) == 0)
			cr.error = CreateResult::SUCCESS;
		else if (errno == EEXIST)
			cr.error = CreateResult::ALREADY_EXISTS;
		else
			cr.error = CreateResult::UNKNOWN;
#endif
		return cr;
	}

	DeleteResult delete_directory(const char *path)
	{
		DeleteResult dr;
#if CROWN_PLATFORM_WINDOWS
		if (RemoveDirectory(path) != 0)
			dr.error = DeleteResult::SUCCESS;
		else if (GetLastError() == ERROR_FILE_NOT_FOUND)
			dr.error = DeleteResult::NO_ENTRY;
		// else if (GetLastError() == ERROR_DIRECTORY
		// 	dr.error = DeleteResult::NOT_DIRECTORY;
		else
			dr.error = DeleteResult::UNKNOWN;
#else
		if (::rmdir(path) == 0)
			dr.error = DeleteResult::SUCCESS;
		else if (errno == ENOENT)
			dr.error = DeleteResult::NO_ENTRY;
		else
			dr.error = DeleteResult::UNKNOWN;
#endif
		return dr;
	}

	const char *getcwd(char *buf, u32 size)
	{
#if CROWN_PLATFORM_WINDOWS
		GetCurrentDirectory(size, buf);
		return buf;
#else
		return ::getcwd(buf, size);
#endif
	}

	const char *getenv(const char *name)
	{
#if CROWN_PLATFORM_WINDOWS
		// GetEnvironmentVariable(name, buf, size);
		return NULL;
#else
		return ::getenv(name);
#endif
	}

	void list_files(const char *path, Vector<DynamicString> &files)
	{
#if CROWN_PLATFORM_WINDOWS
		TempAllocator256 ta_path;
		DynamicString cur_path(ta_path);
		cur_path += path;
		cur_path += "\\*";

		WIN32_FIND_DATA ffd;
		HANDLE file = FindFirstFile(cur_path.c_str(), &ffd);
		if (file != INVALID_HANDLE_VALUE) {
			do {
				const char *dname = ffd.cFileName;

				if (!strcmp(dname, ".") || !strcmp(dname, ".."))
					continue;

				TempAllocator256 ta;
				DynamicString fname(ta);
				fname.set(dname, strlen32(dname));
				vector::push_back(files, fname);
			} while (FindNextFile(file, &ffd) != 0);

			FindClose(file);
		}
#else
		struct dirent *entry;

		DIR *dir = opendir(path);
		if (dir != NULL) {
			while ((entry = readdir(dir))) {
				const char *dname = entry->d_name;

				if (!strcmp(dname, ".") || !strcmp(dname, ".."))
					continue;

				TempAllocator256 ta;
				DynamicString fname(ta);
				fname.set(dname, strlen32(dname));
				vector::push_back(files, fname);
			}

			closedir(dir);
		}
#endif
	}

	///
	s32 access(const char *path, u32 flags)
	{
#if CROWN_PLATFORM_WINDOWS
		return ::_access(path, flags == AccessFlags::EXECUTE ? AccessFlags::EXISTS : flags);
#else
		return ::access(path, flags);
#endif
	}

} // namespace os

} // namespace crown
