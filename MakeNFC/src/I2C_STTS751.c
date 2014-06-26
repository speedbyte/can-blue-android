/**
  ******************************************************************************
  * @file    I2C_STTS751.c
  * @author  MMY Application Team
  * @version V1.0.0
  * @date    19-december-2011
  * @brief   This file provides a set of functions needed to manage the I2C of STTS751 
  *          temperature sensor mounted on M24LR04 demo board 
  *
  *     +-----------------------------------------------------------------+
  *     |                        Pin assignment                           |
  *     +-------------------------------------------+-----------+---------+
  *     |  STM8 I2C Pins                      		  |   STTM75 	|   Pin   |
  *     +-------------------------------------------+-----------+---------+
  *     | M24LR16E_I2C_SDA_PIN/ SDA                 |   SDA     |    6    |
  *     | M24LR16E_I2C_SCL_PIN/ SCL                 |   SCL     |    4    |
  *     | M24LR16E_I2C_SMBUSALERT_PIN/ SMBUS ALERT  |   OS/INT  |    3    |
  *     +---------------------------------------+-----------+-------------+
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


/* Includes ------------------------------------------------------------------*/
#include "I2C_STTS751.h"

/** @addtogroup Utilities
  * @{
  */

/** @addtogroup STM8_EVAL
  * @{
  */

/** @addtogroup Common
  * @{
  */

/** @addtogroup M24LR04_I2C_TSENSOR
  * @brief      This file includes the M24LR04E Temperature Sensor driver of
  *             STM8-EVAL boards.
  * @{
  */

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/


/** @defgroup STM8_EVAL_I2C_TSENSOR_Private_Functions
  * @{
  */
static void I2C_SS_LowLevel_Init(void);
	
	/**
  * @brief  Initializes the M24LR04E_I2C.
  * @param  None
  * @retval None
  */
void I2C_SS_Init(void)
{

  I2C_SS_LowLevel_Init();

  /* I2C DeInit */
  I2C_DeInit(STTS751_I2C);

  /* I2C configuration */
	I2C_Init(STTS751_I2C, STTS75_I2C_SPEED, 0x00, I2C_Mode_I2C,
           I2C_DutyCycle_2, I2C_Ack_Enable, I2C_AcknowledgedAddress_7bit);

  /*!< Enable SMBus Alert interrupt */
//  I2C_ITConfig(M24LR04E_I2C, I2C_IT_ERR, ENABLE);

  /*!< M24LR04E_I2C Init */
  I2C_Cmd(STTS751_I2C, ENABLE);
}

/**
  * @brief  Initializes the M24LR04E_I2C..
  * @param  None
  * @retval None
  */
static void I2C_SS_LowLevel_Init(void)
{
  /*!< M24LR04E_I2C Periph clock enable */
  CLK_PeripheralClockConfig(M24LR04E_I2C_CLK, ENABLE);

  /* Configure PC.4 as Input pull-up, used as TemperatureSensor_INT */
//  GPIO_Init(M24LR04E_I2C_SMBUSALERT_GPIO_PORT, M24LR04E_I2C_SMBUSALERT_PIN, GPIO_Mode_In_FL_No_IT);

}




/**
  * @brief Writes two bytes to the I2C SENSOR. the first is the EEPROM address and the seond the data. 
  * @param[in] ConfigBytes unit 16 containing the data to be 
	* written to the SENSOR for configure it.
  * @retval None
  * @par Required preconditions:
  * None
  */
void I2C_SS_Config ( uint16_t ConfigBytes ) 
{
int32_t I2C_TimeOut = I2C_TIMEOUT;
	
	I2C_AcknowledgeConfig(STTS751_I2C, ENABLE);	
  /* Send START condition */
  I2C_GenerateSTART(STTS751_I2C, ENABLE);
	
  /* Test on EV5 and clear it I2C_EVENT_MASTER_MODE_SELECT */
  while( !I2C_CheckEvent(STTS751_I2C,I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0); 
	
	/* Send EEPROM addreress(STTS751_I2C, STTS751_ADDRESS, I2C_Direction_Transmitter);
	/* Send STLM75 slave address for write */
  I2C_Send7bitAddress(STTS751_I2C, STTS751_ADDRESS, I2C_Direction_Transmitter);
	
	/* Test on EV6 and clear it */
	while( !I2C_CheckEvent(STTS751_I2C,I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)&& I2C_TimeOut-->0);
	
	I2C_GetFlagStatus(STTS751_I2C,I2C_FLAG_ADDR);
	(void)(STTS751_I2C->SR3);
			
	/* Send Address (on 2 bytes) of first byte to be written & wait event detection */
  I2C_SendData(STTS751_I2C,(uint8_t)((ConfigBytes & 0xFF00) >> 8)); /* MSB */
	
  /* Test on EV8 and clear it */
  while (!I2C_CheckEvent(STTS751_I2C,I2C_EVENT_MASTER_BYTE_TRANSMITTING)&& I2C_TimeOut-->0);
	
	I2C_SendData(STTS751_I2C,(uint8_t)((ConfigBytes & 0x00FF))); /* LSB */
	
  /* Test on EV8 and clear it */
  while (!I2C_CheckEvent(STTS751_I2C,I2C_EVENT_MASTER_BYTE_TRANSMITTING)&& I2C_TimeOut-->0);
	
	I2C_GenerateSTOP(STTS751_I2C,ENABLE);

}

/**
  * @brief Reads a block of data from the EEPROM. 
  * @param[in] pBuffer pointer to the buffer that receives the data read
  * from the EEPROM.
  * @param[in] WriteAddr EEPROM's internal address to read from.
  * @param[in] NumByteToWrite EEPROM's number of bytes to read from the EEPROM.  
  * @retval None
  * @par Required preconditions:
  * None
  */
void I2C_SS_BufferRead(uint8_t* pBuffer, uint8_t Pointer_Byte, uint8_t NumByteToRead)
{  
int32_t I2C_TimeOut = I2C_TIMEOUT;

		I2C_AcknowledgeConfig(STTS751_I2C, ENABLE);
	  //------------------------------------- Transmission Phase ------------------
  // Send M24LR04E_I2C START condition 
  I2C_GenerateSTART(STTS751_I2C, ENABLE);
	
	// Test on M24LR04E_I2C EV5 and clear it 
  while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0)  // EV5 
  {
  }
	  
  /* Send slave Address in write direction & wait detection event */
  I2C_Send7bitAddress(STTS751_I2C, STTS751_ADDRESS, I2C_Direction_Transmitter);
  /* Test on EV6 and clear it */
  while ( !I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)&& I2C_TimeOut-->0);
  I2C_GetFlagStatus(STTS751_I2C, I2C_FLAG_ADDR);
	(void)(STTS751_I2C->SR3);
    
	I2C_SendData(STTS751_I2C, (Pointer_Byte)); /* LSB */
  /* Test on EV8 and clear it */
  while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)&& I2C_TimeOut-->0);
	
	/* Send START condition a second time */  
	I2C_GenerateSTART(STTS751_I2C, ENABLE);
	
  /* Test on EV5 and clear it */
  while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0);
	
	/* Send slave Address in read direction & wait event */
  I2C_Send7bitAddress(STTS751_I2C, STTS751_ADDRESS, I2C_Direction_Receiver);
  /* Test on EV6 and clear it */
  while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED)&& I2C_TimeOut-->0);
  I2C_GetFlagStatus(STTS751_I2C, I2C_FLAG_ADDR);
	(void)(STTS751_I2C->SR3);
	
				
	/* While there is data to be read */
	while( NumByteToRead&& I2C_TimeOut-->0)  
	{
		if(NumByteToRead == 1)
		{
			/* Disable Acknowledgement */
			I2C_AcknowledgeConfig(STTS751_I2C,DISABLE);	
			STTS751_I2C->CR2 |= 0x02;		
		}

		/* Test on EV7 and clear it */
		if(I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_BYTE_RECEIVED))
		{      
			/* Read a byte from the SENSOR */
			*pBuffer = I2C_ReceiveData(STTS751_I2C);

			/* Point to the next location where the byte read will be saved */
			pBuffer++; 
			
			/* Decrement the read bytes counter */
			NumByteToRead--;    
		}
		if(NumByteToRead == 0)
		{
			/* Send STOP Condition */
			I2C_GenerateSTOP(STTS751_I2C, ENABLE);
		}
	}
	
	/* Enable Acknowledgement to be ready for another reception */
	I2C_AckPositionConfig(STTS751_I2C,		I2C_AckPosition_Current);	
	I2C_GenerateSTOP(STTS751_I2C, ENABLE);
}



/**
  * @brief Reads a block of data from the EEPROM. 
  * @param[in] pBuffer pointer to the buffer that receives the data read
  * from the EEPROM.
  * @param[in] WriteAddr EEPROM's internal address to read from.
  * @param[in] NumByteToWrite EEPROM's number of bytes to read from the EEPROM.  
  * @retval None
  * @par Required preconditions:
  * None
  */
void I2C_SS_ReadOneByte(uint8_t *pBuffer, uint8_t Pointer_Byte)
{  
int32_t I2C_TimeOut = I2C_TIMEOUT;

		I2C_AcknowledgeConfig(STTS751_I2C, ENABLE);
	  //------------------------------------- Transmission Phase ------------------
  // Send M24LR04E_I2C START condition 
  I2C_GenerateSTART(STTS751_I2C, ENABLE);
	
	// Test on M24LR04E_I2C EV5 and clear it 
  while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0)  // EV5 
  {
  }
	  
  /* Send slave Address in write direction & wait detection event */
  I2C_Send7bitAddress(STTS751_I2C, STTS751_ADDRESS, I2C_Direction_Transmitter);
  /* Test on EV6 and clear it */
  while ( !I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)&& I2C_TimeOut-->0);
  I2C_GetFlagStatus(STTS751_I2C, I2C_FLAG_ADDR);
	(void)(STTS751_I2C->SR3);
    
	I2C_SendData(STTS751_I2C, (Pointer_Byte)); /* LSB */
  /* Test on EV8 and clear it */
  while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_BYTE_TRANSMITTED)&& I2C_TimeOut-->0);
	
	/* Send START condition a second time */  
	I2C_GenerateSTART(STTS751_I2C, ENABLE);
	
  /* Test on EV5 and clear it */
  while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_MODE_SELECT)&& I2C_TimeOut-->0);
	
	/* Send slave Address in read direction & wait event */
  I2C_Send7bitAddress(STTS751_I2C, STTS751_ADDRESS, I2C_Direction_Receiver);

  // Test on EV6 and clear it 
  while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED)&& I2C_TimeOut-->0)  // EV6 
  {
  }

  // Test on EV7 and clear it 
  while (!I2C_CheckEvent(STTS751_I2C, I2C_EVENT_MASTER_BYTE_RECEIVED)&& I2C_TimeOut-->0)  // EV7 
  {
  }

  // Store M24LR04E_I2C received data 
  *pBuffer = I2C_ReceiveData(STTS751_I2C);

  // Disable M24LR04E_I2C acknowledgement 
  I2C_AcknowledgeConfig(STTS751_I2C, DISABLE);

  // Send M24LR04E_I2C STOP Condition 
  I2C_GenerateSTOP(STTS751_I2C, ENABLE);

  // Test on RXNE flag 
  while (I2C_GetFlagStatus(STTS751_I2C, I2C_FLAG_RXNE) == RESET && I2C_TimeOut-->0)
  {}	
}

