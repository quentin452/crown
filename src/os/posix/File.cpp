/*
Copyright (c) 2012 Daniele Bartolini, Simone Boscaratto

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/

#include <cassert>
#include <stdio.h>

#include "OS.h"
#include "File.h"

namespace crown
{

//-----------------------------------------------------------------------------
File::File() :
	m_file_handle(NULL),
	m_mode(SOM_READ)
{
}

//-----------------------------------------------------------------------------
File::~File()
{
	close();
}

//-----------------------------------------------------------------------------
void File::close()
{
	if (m_file_handle != NULL)
	{
		fclose(m_file_handle);
		m_file_handle = NULL;
	}
}

//-----------------------------------------------------------------------------
bool File::is_open() const
{
	return m_file_handle != NULL;
}

//-----------------------------------------------------------------------------
StreamOpenMode File::mode()
{
	return m_mode;
}

//-----------------------------------------------------------------------------
size_t File::size() const
{
	long pos = ftell(m_file_handle);

	fseek(m_file_handle, 0, SEEK_END);

	long size = ftell(m_file_handle);

	fseek(m_file_handle, pos, SEEK_SET);

	return (size_t) size;
}

//-----------------------------------------------------------------------------
bool File::open(const char* path, StreamOpenMode mode)
{
	assert(!is_open());

	const char* c_mode = mode == SOM_READ ? "rb" : SOM_WRITE ? "wb" : "x";

	assert(c_mode[0] != 'x');

	m_file_handle = fopen(path, c_mode);

	if (m_file_handle == NULL)
	{
		os::printf("Could not open file %s", path);

		return false;
	}

	m_mode = mode;

	return true;
}

//-----------------------------------------------------------------------------
size_t File::read(void* data, size_t size)
{
	assert(m_file_handle != NULL);
	assert(data != NULL);

	return fread(data, 1, size, m_file_handle);
}

//-----------------------------------------------------------------------------
size_t File::write(const void* data, size_t size)
{
	assert(m_file_handle != NULL);
	assert(data != NULL);

	return fwrite(data, 1, size, m_file_handle);
}

//-----------------------------------------------------------------------------
void File::seek(size_t position)
{
	assert(m_file_handle != NULL);

	assert(fseek(m_file_handle, (long) position, SEEK_SET) == 0);
}

//-----------------------------------------------------------------------------
void File::seek_to_end()
{
	assert(m_file_handle != NULL);

	assert(fseek(m_file_handle, 0, SEEK_END) == 0);
}

//-----------------------------------------------------------------------------
void File::skip(size_t bytes)
{
	assert(m_file_handle != NULL);

	assert(fseek(m_file_handle, bytes, SEEK_CUR) == 0);
}

//-----------------------------------------------------------------------------
size_t File::position() const
{
	assert(m_file_handle != NULL);

	return (size_t) ftell(m_file_handle);
}

//-----------------------------------------------------------------------------
bool File::eof() const
{
	assert(m_file_handle != NULL);

	return feof(m_file_handle) != 0;
}

} // namespace crown

