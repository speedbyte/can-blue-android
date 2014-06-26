/**
  ******************************************************************************
  * @file    led.c
  * @author  Andreas Sauter
  * @version V1.0.0
  * @date    03/2014
  * @brief   Functions controlling the LED
  ******************************************************************************
  */

#include "stm8l15x.h"
#include "led.h"
#include "discover_board.h"
#include "stm8l15x_conf.h"
  
/**
  * @brief this functions turns the LED on or off 
  * @par bool status : 0 -> turn LED off
  					   1 -> turn LED on
  * @retval none
  */  
void setLED(bool status)
{
	// turn LED off
	if(!status)
	{		
		GPIO_ResetBits(LED_GPIO_PORT,GPIO_Pin_6);
	}
	// turn LED on
	else
	{
		GPIO_SetBits(LED_GPIO_PORT,GPIO_Pin_6);							
	}
}


/**
  * @brief this functions initializes the LED 
  * @par none
  * @retval none
  */  
void initLED()
{
	GPIO_Init( LED_GPIO_PORT, LED_GPIO_PIN, GPIO_Mode_Out_PP_Low_Fast);
	// set to 0 
	GPIOE->ODR &= ~LED_GPIO_PIN;
}
