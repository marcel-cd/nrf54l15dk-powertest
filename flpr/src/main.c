#include <zephyr/sys/printk.h>
#include <zephyr/kernel.h>

int main(void)
{
  printk("HELLO from flpr\n");

  while (true) {
	k_msleep(10000);
  }

  return 0;
}
