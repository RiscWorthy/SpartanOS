#include <uart.h>
#include <dprintf.h>

#define PROMPT "> "
#define PROMPTL sizeof(PROMPT) - 1
#define LINEL 78
#define MAXCOMMANDL (LINEL - PROMPTL - 1)
#define ASCIILOWER 32
#define ASCIIUPPER 126
#define ENTERKEY 13
#define SPECIALKEY 27
#define BACKSPACEKEY 127

static i8 lcommand[LINEL];
static u32 lindex;

u8 enter_pressed(){
	uart_putc_sync('\r');
	uart_putc_sync('\n');
	return 1;
}

void special_key_pressed(u8* up, u32* index, u32 lindex, i8* command, i8* lcommand){
	uart_getc_sync();
	u32 ic = uart_getc_sync();
	switch(ic){
		case 'A':
			// Up
			if(*up == 0){
				*up += 1;
				for(u32 i = *index; i > 0; i--){
					uart_putc_sync('\b');
					uart_putc_sync(' ');
					uart_putc_sync('\b');
				}
				for(u32 i = 0; i < LINEL; i++){
					command[i] = lcommand[i];
					if(i < lindex){
						uart_putc_sync(lcommand[i]);
					}
				}
				*index = lindex;
			}
			break;
		case 'B':
			// Down
			break;
		case 'C':
			// Right
			break;
		case 'D':
			// Left
			break;
		default:
	}
}

void backspace_pressed(u32* index, i8* command){
	if(*index > 0) {
		*index -= 1;
		command[*index] = ' ';
		uart_putc_sync('\b');
		uart_putc_sync(' ');
		uart_putc_sync('\b');
	}
}

void other_key_pressed(u32 c, u32* index, i8* command){
	if(c >= ASCIILOWER && c <= ASCIIUPPER){
		if(*index < MAXCOMMANDL){
			command[*index] = c;
			*index += 1;
			uart_putc_sync(c);
		}
	} else {
		// Non printable character recieved...
		// Uncomment below to see key code recieved...
		// dprintf(50, "GETC: Got: %d\n", c);
	}
}

void handle_close(u32 index, u32* lindex, i8* command, i8* lcommand){
	for(u32 i = 0; i < LINEL; i++){
		lcommand[i] = command[i];
		if(i < index + 1){
			uart_putc_sync(lcommand[i]);
		}
	}
	*lindex = index;
	uart_putc_sync('\n');
}

// Waits for user to press enter to return...
// Pressing up once retrieves the latest run command
// Ascii printable chars are printed to shell
// Line starts with a prompt "> " which cannot be erased
// Line limit is 78 chars to look nice in standard terminal environments
// Command can contain 75 chars after accounting for padding.
// Currently all the shell does on enter is echo the provided command.
void shell(void) {
	dprintf(PROMPTL, PROMPT);
	i8 command[LINEL];
	for(i32 i = 0; i < LINEL; i++){
		command[i] = 0;
	}
	u32 index = 0;
	u8 close = 0;
	u8 up = 0;
	while(1){
		u32 c = uart_getc_sync();
		switch(c) {
		case ENTERKEY:
			close = enter_pressed();
			break;
		case SPECIALKEY:
			special_key_pressed(&up, &index, lindex, command, lcommand);
			break;
		case BACKSPACEKEY:
			backspace_pressed(&index, command);
			break;
		default:
			other_key_pressed(c, &index, command);
		}
		if(close > 0){
			handle_close(index, &lindex, command, lcommand);
			break;
		}
	}
}