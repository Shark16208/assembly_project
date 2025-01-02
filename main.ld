MEMORY
{
  RAM : ORIGIN = 0x80000000, LENGTH = 4k
}

/* SECTIONS
{
.text : {
    *(.text)
    *(.text.*)
  } > RAM
.data : {
    *(.data)
    *(.data.*)
}
} */

SECTIONS
{
  /* . = 0x80000000; */
  .text :
  {
    *(.text*)
    *(.text.*)
  } > RAM
  .data :
  {
    *(.data*)
    *(.data.*)
  } > RAM
  .bss :
  {
    *(.bss*)
    *(.bss.*)
  } > RAM
}
