/**
  ******************************************************************************
  * @file    init.c
  * @author  Andreas Sauter
  * @version V1.0.0
  * @date    03/2014
  * @brief   Functions controlling the LED
  ******************************************************************************
  */

#include "stm8l15x.h"
#include "stm8l15x_conf.h"
#include "init.h"
#include "led.h"
#include "lcd.h"
#include "button.h"

/**
  * @brief function to call initialize functions
  * @par Parameters None
  * @retval none
  */
void Initialize()
{
	/* initialize LCD and turn it off */
	initLCD();
	
	/* LED button init: GPIO set in push pull */
	initLED();
	
	/* initialize button*/
	initButton();
}
  
