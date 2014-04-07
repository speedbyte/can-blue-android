/**
  ******************************************************************************
  * @file    button.c
  * @author  Andreas Sauter
  * @version V1.0.0
  * @date    03/2014
  * @brief   Functions controlling the LCD
  ******************************************************************************
  */

#include "stm8l15x.h"
#include "stm8l15x_it.h"
#include "discover_functions.h"
#include "discover_board.h"
 
#include "button.h"
#include "stm8l15x_conf.h"

/**
  * @brief this function initializes the Button 
  * @par none
  * @retval none
  */
void initButton()
{	
	/* USER button init: GPIO set in input interrupt active mode */
	GPIO_Init( BUTTON_GPIO_PORT, USER_GPIO_PIN, GPIO_Mode_In_FL_IT);
	EXTI_SetPinSensitivity(EXTI_Pin_7, EXTI_Trigger_Falling);
}