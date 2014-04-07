/**
  ******************************************************************************
  * @file    lcd.c
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
#include "stm8l_discovery_lcd.h"  
  
#include "lcd.h"
#include "stm8l15x_conf.h"

/* LCD bar graph: used for display active function */
extern uint8_t t_bar[2];

/**
  * @brief this function initializes the LCD 
  * @par none
  * @retval none
  */
void initLCD()
{
	/* Initializes the LCD glass */ 
	LCD_GLASS_Init();
	
	//* Init Bar on LCD all are OFF
	BAR0_OFF;
	BAR1_OFF;
	BAR2_OFF;
	BAR3_OFF;		
}


/**
  * @brief this function clears the LCD RAM
  * @par none
  * @retval none
  */
void clearLCD()
{
	/* function provided by ST: clears whole LCD RAM */
	LCD_GLASS_Clear();
}