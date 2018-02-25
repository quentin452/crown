/*
 * Copyright 2011-2018 Branimir Karadzic. All rights reserved.
 * License: https://github.com/bkaradzic/bx#license-bsd-2-clause
 */

#ifndef BX_EASING_H_HEADER_GUARD
#define BX_EASING_H_HEADER_GUARD

#include "math.h"

// Reference:
// http://easings.net/
// http://robertpenner.com/easing/

namespace bx
{
	///
	struct Easing
	{
		enum Enum
		{
			Linear,
			Step,
			SmoothStep,
			InQuad,
			OutQuad,
			InOutQuad,
			OutInQuad,
			InCubic,
			OutCubic,
			InOutCubic,
			OutInCubic,
			InQuart,
			OutQuart,
			InOutQuart,
			OutInQuart,
			InQuint,
			OutQuint,
			InOutQuint,
			OutInQuint,
			InSine,
			OutSine,
			InOutSine,
			OutInSine,
			InExpo,
			OutExpo,
			InOutExpo,
			OutInExpo,
			InCirc,
			OutCirc,
			InOutCirc,
			OutInCirc,
			InElastic,
			OutElastic,
			InOutElastic,
			OutInElastic,
			InBack,
			OutBack,
			InOutBack,
			OutInBack,
			InBounce,
			OutBounce,
			InOutBounce,
			OutInBounce,

			Count
		};
	};

	///
	typedef float (*EaseFn)(float _t);

	///
	EaseFn getEaseFunc(Easing::Enum _enum);

	/// Linear.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                         *******
	///      |                                                   *******
	///      |                                            ********
	///      |                                      *******
	///      |                                *******
	///      |                         ********
	///      |                   *******
	///      |            ********
	///      |      *******
	///      +*******--------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeLinear(float _t);

	/// Step.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |                                ********************************
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |
	///      +********************************-------------------------------->
	///      |
	///      |
	///      |
	///      |
	///      |
	///
	float easeStep(float _t);

	/// Smooth step.
	///
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                   *************
	///      |                                             *******
	///      |                                        ******
	///      |                                    *****
	///      |                                *****
	///      |                           *****
	///      |                       *****
	///      |                  ******
	///      |            *******
	///      +*************--------------------------------------------------->
	///      |
	///      |
	///      |
	///      |
	///      |
	///
	float easeSmoothStep(float _t);

	/// Quad.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                            ****
	///      |                                                         ****
	///      |                                                     *****
	///      |                                                 *****
	///      |                                             *****
	///      |                                        ******
	///      |                                   ******
	///      |                            ********
	///      |                    *********
	///      +*********************------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInQuad(float _t);

	/// Out quad.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                           *********************
	///      |                                   *********
	///      |                             *******
	///      |                       ******
	///      |                  ******
	///      |              *****
	///      |          *****
	///      |      *****
	///      |   ****
	///      +****------------------------------------------------------------>
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutQuad(float _t);

	/// In out quad.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                 ***************
	///      |                                           *******
	///      |                                       *****
	///      |                                   *****
	///      |                                ****
	///      |                            *****
	///      |                        *****
	///      |                    *****
	///      |              *******
	///      +***************------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInOutQuad(float _t);

	/// Out in quad.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                            ****
	///      |                                                        *****
	///      |                                                    *****
	///      |                                              *******
	///      |                                ***************
	///      |                 ****************
	///      |           *******
	///      |       *****
	///      |   *****
	///      +****------------------------------------------------------------>
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutInQuad(float _t);

	/// In cubic.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                             ***
	///      |                                                           ***
	///      |                                                        ****
	///      |                                                      ***
	///      |                                                  ****
	///      |                                               ****
	///      |                                          ******
	///      |                                     ******
	///      |                             *********
	///      +******************************---------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInCubic(float _t);

	/// Out cubic.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                                  ******************************
	///      |                          *********
	///      |                     ******
	///      |                ******
	///      |             ****
	///      |          ****
	///      |       ****
	///      |    ****
	///      |  ***
	///      +***------------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutCubic(float _t);

	/// In out cubic.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                                             *******************
	///      |                                        ******
	///      |                                     ****
	///      |                                  ****
	///      |                                ***
	///      |                             ****
	///      |                           ***
	///      |                       ****
	///      |                  ******
	///      +*******************--------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInOutCubic(float _t);

	/// Out in cubic.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                             ***
	///      |                                                           ***
	///      |                                                       ****
	///      |                                                  ******
	///      |                                *******************
	///      |             ********************
	///      |        ******
	///      |     ****
	///      |  ****
	///      +***------------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutInCubic(float _t);

	/// In quart.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                              **
	///      |                                                            ***
	///      |                                                          ***
	///      |                                                        ***
	///      |                                                     ****
	///      |                                                  ****
	///      |                                               ****
	///      |                                          ******
	///      |                                    *******
	///      +************************************---------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInQuart(float _t);

	/// Out quart.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                            ************************************
	///      |                     ********
	///      |                ******
	///      |             ****
	///      |          ****
	///      |       ****
	///      |     ***
	///      |   ***
	///      | ***
	///      +**-------------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutQuart(float _t);

	/// In out quart.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                                          **********************
	///      |                                      *****
	///      |                                   ****
	///      |                                 ***
	///      |                                **
	///      |                              ***
	///      |                            ***
	///      |                         ****
	///      |                     *****
	///      +**********************------------------------------------------>
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInOutQuart(float _t);

	/// Out in quart.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                              **
	///      |                                                            ***
	///      |                                                         ****
	///      |                                                     *****
	///      |                               ***********************
	///      |          ***********************
	///      |      *****
	///      |   ****
	///      | ***
	///      +**-------------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutInQuart(float _t);

	/// In quint.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                              **
	///      |                                                             **
	///      |                                                           ***
	///      |                                                         ***
	///      |                                                       ***
	///      |                                                     ***
	///      |                                                  ****
	///      |                                              *****
	///      |                                        *******
	///      +*****************************************----------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInQuint(float _t);

	/// Out quint.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |                                                              **
	///      |                       *****************************************
	///      |                 *******
	///      |             *****
	///      |          ****
	///      |        ***
	///      |      ***
	///      |    ***
	///      |  ***
	///      | **
	///      +**-------------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutQuint(float _t);

	/// In out quint.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |                                                              **
	///      |                                        ************************
	///      |                                     ****
	///      |                                   ***
	///      |                                 ***
	///      |                                **
	///      |                              ***
	///      |                            ***
	///      |                          ***
	///      |                       ****
	///      +************************---------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInOutQuint(float _t);

	/// Out in quint.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                              **
	///      |                                                            ***
	///      |                                                          ***
	///      |                                                       ****
	///      |                               *************************
	///      |        **************************
	///      |     ****
	///      |   ***
	///      | ***
	///      +**-------------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutInQuint(float _t);

	/// In sine.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                            ****
	///      |                                                       *****
	///      |                                                   *****
	///      |                                               *****
	///      |                                          ******
	///      |                                     ******
	///      |                                ******
	///      |                          *******
	///      |                  *********
	///      +*******************--------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInSine(float _t);

	/// Out sine.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                             *******************
	///      |                                     *********
	///      |                               *******
	///      |                          ******
	///      |                     ******
	///      |                ******
	///      |            *****
	///      |        *****
	///      |    *****
	///      +*****----------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutSine(float _t);

	/// In out sine.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                  **************
	///      |                                             ******
	///      |                                        ******
	///      |                                    *****
	///      |                                *****
	///      |                           ******
	///      |                       *****
	///      |                  ******
	///      |             ******
	///      +**************-------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInOutSine(float _t);

	/// Out in sine.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                           *****
	///      |                                                       *****
	///      |                                                  ******
	///      |                                             ******
	///      |                                **************
	///      |                  ***************
	///      |             ******
	///      |        ******
	///      |    *****
	///      +*****----------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutInSine(float _t);

	/// In exponential.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                                                              **
	///      |                                                            **
	///      |                                                           **
	///      |                                                         ***
	///      |                                                       ***
	///      |                                                     ***
	///      |                                                 ****
	///      |                                          ********
	///      +*******************************************--------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInExpo(float _t);

	/// Out exponential.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                     *******************************************
	///      |              ********
	///      |           ****
	///      |        ****
	///      |      ***
	///      |    ***
	///      |   **
	///      |  **
	///      | **
	///      +*--------------------------------------------------------------->
	///      |
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutExpo(float _t);

	/// In out exponential.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                                       *************************
	///      |                                    ****
	///      |                                  ***
	///      |                                 **
	///      |                                **
	///      |                               *
	///      |                             **
	///      |                           ***
	///      |                        ****
	///      +*************************--------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInOutExpo(float _t);

	/// Out in exponential.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                                                             **
	///      |                                                           ***
	///      |                                                        ****
	///      |                               **************************
	///      |       **************************
	///      |    ****
	///      |  ***
	///      | **
	///      +**-------------------------------------------------------------->
	///      |
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutInExpo(float _t);

	/// In circle.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                                                              **
	///      |                                                             **
	///      |                                                          ****
	///      |                                                       ****
	///      |                                                   *****
	///      |                                             *******
	///      |                                      ********
	///      |                           ************
	///      +****************************------------------------------------>
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInCirc(float _t);

	/// Out circle.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                    ****************************
	///      |                         ************
	///      |                  ********
	///      |            *******
	///      |        *****
	///      |     ****
	///      |   ***
	///      | **
	///      |**
	///      +*--------------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutCirc(float _t);

	/// In out circle.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                            ********************
	///      |                                      *******
	///      |                                  *****
	///      |                                ***
	///      |                                *
	///      |                               **
	///      |                             ***
	///      |                         *****
	///      |                   *******
	///      +********************-------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInOutCirc(float _t);

	/// Out in circle.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                                                             ***
	///      |                                                         *****
	///      |                                                   *******
	///      |                                ********************
	///      |            *********************
	///      |      *******
	///      |  *****
	///      |***
	///      +*--------------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutInCirc(float _t);

	/// Out elastic.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                                                              **
	///      |                                                              *
	///      |                                                             **
	///      |                                                             *
	///      |                                                             *
	///      |                                                            *
	///      |                                                            *
	///      |                                           *****           **
	///      +-***********--------***********---------****---***---------*---->
	///      |**         **********         ***********        **       **
	///      |                                                   **     *
	///      |                                                    **   *
	///      |                                                     *****
	///      |
	///
	float easeOutElastic(float _t);

	/// In elastic.
	///
	///      ^
	///      |
	///      |      *****
	///      |      *   **
	///      |     **     **
	///      |    **       **         **********         **********         **
	///      |    *         ***   *****        ***********        ***********
	///      |   **           *****
	///      |   *
	///      |   *
	///      |  **
	///      |  *
	///      | **
	///      | *
	///      |**
	///      +*--------------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInElastic(float _t);

	/// In out elastic.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |                                   ***
	///      |                                  **  **    *****    ******    *
	///      |                                  *    ******   ******    ******
	///      |                                 *
	///      |                                 *
	///      |                                **
	///      |                                *
	///      |                               **
	///      |                               *
	///      |                              *
	///      |                              *
	///      +******----******----*****----**--------------------------------->
	///      |*    ******    ******   ***  *
	///      |                          ***
	///      |
	///      |
	///      |
	///
	float easeInOutElastic(float _t);

	/// Out in elastic.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                                                               *
	///      |                                                              *
	///      |   ***                                                        *
	///      |  **  **    *****    ******    *******    ******    *****    **
	///      |  *    ******   ******    *******    ******    ******   ***  *
	///      | *                                                        ***
	///      | *
	///      |**
	///      +*--------------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutInElastic(float _t);

	/// In back.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                                                             **
	///      |                                                            **
	///      |                                                           **
	///      |                                                          **
	///      |                                                         **
	///      |                                                       **
	///      |                                                      **
	///      |                                                    **
	///      +*-------------------------------------------------***----------->
	///      |*************                                   ***
	///      |            *******                          ****
	///      |                  *******                *****
	///      |                        ******************
	///      |
	///
	float easeInBack(float _t);

	/// Out back.
	///
	///      ^
	///      |
	///      |                      ******************
	///      |                  *****                *******
	///      |               ****                          *******
	///      |             ***                                   *************
	///      |           ***
	///      |          **
	///      |        ***
	///      |       **
	///      |     ***
	///      |    **
	///      |   **
	///      |  **
	///      | **
	///      +**-------------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutBack(float _t);

	/// In out back.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |                                         **************
	///      |                                      ****            **********
	///      |                                     **
	///      |                                   ***
	///      |                                  **
	///      |                                 **
	///      |                                **
	///      |                               **
	///      |                             **
	///      |                            **
	///      |                           **
	///      +*------------------------**------------------------------------->
	///      |**********            ****
	///      |         **************
	///      |
	///      |
	///      |
	///
	float easeInOutBack(float _t);

	/// Out in back.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                               *
	///      |                                                             **
	///      |                                                            **
	///      |         **************                                    **
	///      |      ****            ***********                        **
	///      |     **                         **********            ****
	///      |   ***                                   **************
	///      |  **
	///      | **
	///      +**-------------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutInBack(float _t);

	/// Out bounce.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                        ********
	///      |                                                     ****
	///      |                                                   ***
	///      |                                                 ***
	///      |                                               ***
	///      |                                              **
	///      |                                            **
	///      |                      **************       **
	///      |                   ****            ****   **
	///      +********************------------------****---------------------->
	///      |*     *
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutBounce(float _t);

	/// In bounce.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |                                                         *
	///      |                      ****                  ********************
	///      |                    ***  ****            ****
	///      |                   **       **************
	///      |                  **
	///      |                ***
	///      |              ***
	///      |            ***
	///      |          ***
	///      |       ****
	///      +********-------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeInBounce(float _t);

	/// In out bounce.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |                                                            *
	///      |                                          *****     ************
	///      |                                         **   *******
	///      |                                       ***
	///      |                                     ***
	///      |                                ******
	///      |                          *******
	///      |                        ***
	///      |                       **
	///      |           *******   **
	///      +************------****------------------------------------------>
	///      |*  *
	///      |
	///      |
	///      |
	///      |
	///
	float easeInOutBounce(float _t);

	/// Out in bounce.
	///
	///      ^
	///      |
	///      |
	///      |
	///      |
	///      |
	///      |                                                          ******
	///      |                                                        ***
	///      |                                                       **
	///      |                                           *******   **
	///      |                            *   ************      ****
	///      |          *****     *************  *
	///      |         **   *******
	///      |       ***
	///      |     ***
	///      +******---------------------------------------------------------->
	///      |*
	///      |
	///      |
	///      |
	///      |
	///
	float easeOutInBounce(float _t);

} // namespace bx

#include "inline/easing.inl"

#endif // BX_EASING_H_HEADER_GUARD
