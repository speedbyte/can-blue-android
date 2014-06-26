/**
  ******************************************************************************
  * @file    I2C_M24LR16E-R.h
  * @author  MMY Application Team
  * @version V1.0.0
  * @date    19-december-2011
  * @brief   This file contains all the functions prototypes for the 
  *          firmware I2C driver.
  ******************************************************************************
  * @attention
  *
  * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
  * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
  * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
  * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
  * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
  * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
  *
  * <h2><center>&copy; COPYRIGHT 2011 STMicroelectronics</center></h2>
  ******************************************************************************
  */  
  
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __I2C_TSENSOR_H
#define __I2C_TSENSOR_H

#include "stm8l15x.h"
#include "stm8l15x_i2c.h"
#include "discover_board.h"

// stts75 I2C address
#define STTS751_ADDRESS 									0x72 /* I2C DeviceSelect */
#define STTS751_STOP				 							0x0340
#define STTS751_ONESHOTMODE 							0x0F00
#define I2C_TIMEOUT         							(uint32_t)0x000FF /*!< I2C Time out */
#define STTS75_I2C_SPEED      20000 /*!< I2C Speed */

void I2C_SS_Init(void);
void I2C_SS_Config(uint16_t ConfigBytes);
void I2C_SS_BufferRead(uint8_t* pBuffer, uint8_t Pointer_Byte, uint8_t NumByteToRead);
void I2C_SS_ReadOneByte(uint8_t *pBuffer, uint8_t Pointer_Byte);


/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */ 

/**
  * @}
  */
	
#endif 
/******************* (C) COPYRIGHT 2011 STMicroelectronics *****END OF FILE****/