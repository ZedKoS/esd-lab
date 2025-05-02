int main(void)
{

 //PORT REGISTERS

 volatile unsigned int* GPIOA_MODER = (unsigned int*) (0x40020000 + 0x00);
 volatile unsigned int* GPIOA_ODR = (unsigned int*) (0x40020000 + 0x14);
 volatile unsigned int* GPIOC_MODER = (unsigned int*) (0x40020000 + 0x0800 + 0x00);
 volatile unsigned int* GPIOC_PUPDR = (unsigned int*) (0x40020000 + 0x0800 + 0x0C);
 volatile unsigned int* GPIOC_IDR = (unsigned int*) (0x40020000 + 0x0800 + 0x10);

 //CLOCK REGISTERS
 volatile unsigned int* RCC_AHB1ENR = (unsigned int*) (0x40023800 + 0x30);

 //VARIABLES
 //ENABLE PORT CLOCK:
 // this ensure that the peripheral is enabled and connected to the AHB1 bus
 *RCC_AHB1ENR |= 0x01U;
 *RCC_AHB1ENR |= 0x04U;
 //CONFIGURE PORT: set MODER[11:10] = 0x1
 *GPIOA_MODER |= 0x400;
 //CONFIGURE PORT: set MODER[27:26] = 0x1
 *GPIOC_MODER &= ~0xC000000;
 //CONFIGURE PORT: set P13 to PULLUP
 *GPIOC_PUPDR |= 0x4000000;
 //SWITCH ON THE LED: set ODR[5] = 0x1, that is pulls PA5 high
 *GPIOA_ODR |= 0x20;
 // Application code (Infinite loop)
	
 while (1)
 {
	 int push_status = (*GPIOC_IDR >> 13) & 0x1;
	 if(push_status == 1){
		 *GPIOA_ODR &= ~(0x20); //complements bit => toggles LED
	
	 } else{
	
		 *GPIOA_ODR |= (0x20); //complements bit => toggles LED
	 }

 }
}
