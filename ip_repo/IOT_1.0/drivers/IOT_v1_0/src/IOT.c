
/***************************** Include Files *******************************/
#include "IOT.h"

/************************** Function Definitions ***************************/
void setDesiredTemperature(unsigned char temperature)
{
    IOT_mWriteReg (base , IOT_S00_AXI_SLV_REG0_OFFSET , 0x00000000 + temp);
}

void lightOn()
{
    IOT_mWriteReg (base , IOT_S00_AXI_SLV_REG0_OFFSET , 0x00010000);
}

void lightOff()
{
    IOT_mWriteReg (base , IOT_S00_AXI_SLV_REG0_OFFSET , 0x00020000);
}

void motionDetectionSetEnable()
{
    IOT_mWriteReg (base , IOT_S00_AXI_SLV_REG0_OFFSET , 0x00050000);
}

void motionDetectionSetDisable()
{
    IOT_mWriteReg (base , IOT_S00_AXI_SLV_REG0_OFFSET , 0x00060000);
}
