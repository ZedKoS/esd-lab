void SysTick_Handler(void)
{
  /* USER CODE BEGIN SysTick_IRQn 0 */
static int x=0x12c; // What is this number?
for(int i = 0; i<x; i++);
x = (x >> 2) | (((x & 1) ^ (x & 2)) << 5);

LL_GPIO_WriteReg(GPIOA, ODR, (LL_GPIO_ReadReg(GPIOA, ODR) ^ (0x400)));
LL_GPIO_WriteReg(GPIOA, ODR, (LL_GPIO_ReadReg(GPIOA, ODR) ^ (0x20)));
  /* USER CODE END SysTick_IRQn 0 */
  HAL_IncTick();
  /* USER CODE BEGIN SysTick_IRQn 1 */

  /* USER CODE END SysTick_IRQn 1 */
}
