/**
******************************************************************************
* @file    misc.c
* @author  Microcontroller Division
* @version V1.2.1
* @date    10/2010
* @brief   Discover demo functions
******************************************************************************
* @copy
*
* THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
* WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
* TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
* DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
* FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
* CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
*
* <h2><center>&copy; COPYRIGHT 2010 STMicroelectronics</center></h2>
*/

/* Includes ------------------------------------------------------------------*/


#include "misc.h"


/** @addtogroup MISC
 * 	@{
 */


/**  
 * @brief  
 * @param  
 * @retval None
 */
void itoa(uint32_t val, uint8_t base,uint8_t *buf)
{            
//static uint8_t buf[32] = {0};  // 32 bits
uint8_t i = 30;

	for(; val && i ; --i, val /= base)
	 	buf[i] = "0123456789abcdef"[val % base];

	//return &buf[i+1];
}

/******************* (C) COPYRIGHT 2012 STMicroelectronics *****END OF FILE****/