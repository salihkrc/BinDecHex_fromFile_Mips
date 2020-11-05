

##################### MAIN IDEA OF ALGORITHM ######################
# 0 | 1 | 2 | 3 | 4 | 5 |
# 1       2       7   7
#
# Here The Slot [0] represents the Input Data Type ( 1 For DEC, 2 For BIN, 3 For HEX ), Slot[2] represents the Output Data Type, Slot[4] and up the actual data.  
#
# 1. READS INPUT DATA TYPE FROM FILE
# 2. READS OUTPUT DATA TYPE FROM FILE
# 3. READS DATA FROM FILE
# 4. CONVERT INPUT DATA DO DECIMAL
# 5. CONVERT TO THE REQUESTED TYPE FROM DECIMAL
# 6. PRINT CONVERTED DATA
#  ------ATTENTION------
# + HEXADECIMAL VALUES SHOULD BE TYPED(ENTERED) AS A CAPITAL LETTER ex. 7B not 7b !
#################################################################
.data

filename : .asciiz "C:\\Users\\Salih\\Desktop\\portofolio\\MIPS_PROJECTS\\from_file_to_DEC_BIN_HEX\\data.txt" # file name !!!ATTENTION!!! DO NO FORGET TO PASS HERE THE PATH OF data.txt FILE ON YOUR MACHINE 
fBuffer  : .space 1024  # file data stored here 
delim1   : .word 10  # this represents 
delim2   : .word 13


bufferhex: .space 10
bufferoct: .space 10
bufferbin: .space 10
ten: .asciiz "A"
eleven: .asciiz "B"
twelve: .asciiz "C"
thirteen: .asciiz "D"
fourteen: .asciiz "E"
fifteen: .asciiz "F"


#######MESSAGES#########################################
msg0: .asciiz "*WELCOME TO THE PROGRAM*\n"
msg1: .asciiz "Please Select Input Data Type:\n"
msg2: .asciiz "Press 1 for DEC, 2 for BIN, 3 for HEX \n"
msg3: .asciiz "Please Enter The Data: "
msg4: .asciiz "Please Select Output Data Type:\n"
prompt3: .asciiz "Given number in HEX: \n"
prompt0: .asciiz "Enter number in DEC: \n" 
prompt1: .asciiz "Given number in BIN: \n"
fmsg0    : .asciiz "File Opened...\n"
fmsg1    : .asciiz "File Data :\t"
fmsg2    : .asciiz "File Closed...\n"
#######################################################
nwline: .asciiz "\n"  # This is newline

buffer: .asciiz "----------"


# 
# HEXADECIMAL VALUES WITH CAPITAL !!!!!!!!!!!!!!!!! ###############
.text
.globl main
main:
#Printing welcome message
li $v0, 4
la $a0, msg0
syscall

li $v0, 13       # system call for open file
la $a0, filename # input file name
li $a1, 0        # flag for reading
li $a2, 0        # mode is ignored
syscall          # open a file
move $s0, $v0    # save the file descriptor 

# Print message to show that file is opened :
li $v0, 4
la $a0, fmsg0
syscall # Print fmsg0

# read from file

li $v0, 14      # system call for reading from file
move $a0, $s0   # file descriptor
la $a1, fBuffer # address of buffer from which to read
li $a2, 1023      # hardcoded buffer length
syscall         # read from file

# Print message for File Data :

li $v0, 4
la $a0, fmsg1
syscall # Print fmsg1

# Print File Data

li $v0, 4
la $a0, fBuffer
syscall

#Print NewLine

li $v0, 4
la $a0, nwline
syscall

# close the File

li $v0, 16     # close file syscall code
move $a0, $s0  # file descriptor to close
syscall        # execute

# Print Message tha shows file is closed

li $v0, 4
la $a0, fmsg2
syscall # print msg2


# HERE Get the first value from file to make selection

li $s0, 0 # index of a fBuffer
li $s7, 2 # second index for fBuffer

lb $t3, fBuffer($s0)  # load selection for input data type
lb $s6, fBuffer($s7)  # load selection for output data type

#selections 
li $t0, '1'
li $t1, '2'
li $t2, '3'
##########

#finding the selection of user
beq $t3, $t0, read_dec 
beq $t3, $t1, read_bin
beq $t3, $t2, read_hex
#######################

read_dec:    # reads dec

li $s0, 4
j conv_ToDEC



cont_read_dec:


###selections#####
li $t1, '1'
li $t2, '2'
li $t3, '3'
##########






#compare selection to find it
beq $s6, $t1, print_dec 
beq $s6, $t2, print_bin
beq $s6, $t3, print_hex

##################################
#################################

read_bin: # read binary value


j CopytoBuffer1

continue_1:

jal bin_to_dec # jump and link to convert from BIN to DEC first

read_hex:   # read hexadecimal value

j CopytoBuffer2

continue_2:

jal hex_to_dec # jump and link to convert to DEC first

bin_to_dec: # convert from binary to decimal 
li $t0, '0' # 0 in string form
li $t1, '1' # 1 in string form 
li $t9, '-' # NULL value in buffer
li $t2, 2   # two value for the calculation
li $t3, 1   # one value for the multiplication 
li $t4, 0   # counter
li $t5, -1  # power counter (shift amount)
li $s1, 1   # 
li $s7, 1 # ONE VALUE

loop1:  # this loop counts the LEN of the buffer (input value in bin)
 
lb $s0, buffer($t4)  # gets byte (0 or 1)
addi $t4, $t4, 1     # inc counter 
beq $s0, $t0, loop1  # until you see value different from 0 continue
beq $s0, $t1, loop1  # until you see value different from 1 continue


cont:
sub $t4, $t4, 1 # sub the extra value from the counter 
add $t6, $zero, $t4  # store max value of counter to the $t6


loop2:
lb $s0, buffer($t4) # read 0 and 1s from the end of buffer
beq $t5, $t6, finish_conv # if counter is equal to old value of $t4 finish
beq $s0, $t0, zerofound   # if you find zero go to function zerofound
beq $s0, $t1, onefound    # if you find one go to function onefound

addi $t5, $t5, 1         # inc counter
addi $t4, $t4, -1        # dic counter of buffer  
j loop2                  # loop
 
zerofound:              # zerofound  # do nothing here because 0x2^n = 0
addi $t4, $t4, -1       # dic counter of buffer  
addi $t5, $t5, 1        # inc counter
beq $t5, $t6, finish_conv # if counter is equal to old value of $t4 finish
j loop2                 #loop

onefound:

sllv $s3, $s7, $t5  # shift the 1 according to the value of the counter = 2^$t5
add $s4, $s4, $s3   # add to the full sum

addi $t4, $t4, -1   # dic counter of buffer 
addi $t5, $t5, 1    # inc counter
beq $t5, $t6, finish_conv # if counter is equal to old value of $t4 finish

j loop2                    ################VALUE IN $S4


finish_conv:

add $t0, $zero $s4  # move the converted value to $t0

#selections
li $t1, '1'
li $t2, '2'
li $t3, '3'
##########



# check the selection and find it
beq $s6, $t1, print_dec 
beq $s6, $t2, print_bin
beq $s6, $t3, print_hex

################################################
#################################################

hex_to_dec:


fromHexaStringToDecimal:
    # start counter
    la   $t2, buffer      # load inputNumber address to t2
    li   $t8, 1                      # start our counter
    li   $a0, 0                      # output number
    j    hexaStringToDecimalLoop

hexaStringToDecimalLoop:
    lb   $t7, ($t2)
    ble  $t7, '9', inputSub48       # if t7 less than or equal to char '9' inputSub48
    addi $t7, $t7, -55              # convert from string (ABCDEF) to int
    j    inputHexaNormalized
inputHexaNormalized:
    blt  $t7, $zero, convertFinish  # print int if t7 < 0
    li   $t6, 16                    # load 16 to t6
    mul  $a0, $a0, $t6              # t8 = t8 * t6
    add  $a0, $a0, $t7              # add t7 to a0
    addi $t2, $t2, 1                # increment array position
    j    hexaStringToDecimalLoop

inputSub48:
    addi $t7, $t7, -48              # convert from string (ABCDEF) to int
    j    inputHexaNormalized

    convertFinish:

    add $t0, $zero, $a0

#selections
li $t1, '1'
li $t2, '2'
li $t3, '3'
##########



# check the selection and find it
beq $s6, $t1, print_dec 
beq $s6, $t2, print_bin
beq $s6, $t3, print_hex

################################################################################
################################################################################



print_dec:

li $v0, 1
move $a0, $t0 # just print the DEC value
syscall

jal FINISH

print_bin:

li $t1, 1 # index for bufferbin
li $t2, 2

li $t7, 1 #index for bufferhex
li $t8, 16

loop:
div $t0, $t2   # divide by two
mflo $t0       # remainder in $t0  (div)
mfhi $t3       # divedend in $t3   (mod)
sb $t3, bufferbin($t1)  #store value to the buffer
addi $t1, $t1, 1       # inc buffer counter

beqz $t0, prom        # go to prom function if $t0 is equal to 0

j loop  # loop

prom:

li $v0, 4
la $a0, prompt1 # prompt message
syscall

jal print 



print:

lb $t4, bufferbin($t1) # get one by one the binary values 0 or 1

move $a0, $t4
li $v0, 1         # print them
syscall

addi $t1, $t1, -1   # dic buffer counter
beqz $t1, FINISH    # in counter is zero Finish the printing
j print    # loop to print
 


nop
##############################################
################################################

print_hex:

add $s6, $zero, $t0   # move DEC value to the #s6 
li $t7, 0             # initialize the counter 
li $t8, 16            # 16 for the divide

calchex:

div $s6, $t8        # divide $s6 by 16
mflo $s6            # remainder in $s6 (div)
mfhi $s7            # dividen in $s7   (mod)
sb $s7, bufferhex($t7) # store hex byte in the buffer 
addi $t7, $t7, 1     # inc counter

beqz $s6, promhex  # if remainder is equal to zero finish the convert and go to print

j calchex      # loop for calculation
nop
promhex:

li $v0, 4
la $a0, nwline   # print new line
syscall

li $v0, 4
la $a0, prompt3 # prompt message
syscall

jal clearreg # clear registers

clearreg:

li $t0, 10  # store the values to registers
li $t1, 11
li $t2, 12
li $t3, 13
li $s0, 14
li $s4, 15
li $s2, 0

jal printhex


printhex:

blt $t7,$zero, FINISH # if counter is less than 0 finish the printing
lb $s2, bufferhex($t7)

beq $s2, $t0, printten      # if $s2 = 10 print A
beq $s2, $t1, printeleven   # if $s2 = 11 print B
beq $s2, $t2, printtwelve   # if $s2 = 12 print C
beq $s2, $t3, printthirteen # if $s2 = 13 print D
beq $s2, $s0, printfourteen # if $s2 = 14 print E
beq $s2, $s4, printfifteen  # if $s2 = 15 print F

move $a0, $s2               # if not above print normal 0-9 
li $v0, 1
syscall

addi $t7, $t7, -1       # dic counter


j printhex

nop

############### THESE FUNCTIONS HERE ARE PRINTING A,B,C,D,E,F instead of 10,11,12,13,14,15 ################
printten:

li $v0, 4
la $a0, ten
syscall
addi $t7, $t7, -1
j printhex



printeleven:

li $v0, 4
la $a0, eleven
syscall

addi $t7, $t7, -1
j printhex



printtwelve:

li $v0, 4
la $a0, twelve
syscall

addi $t7, $t7, -1
j printhex


printthirteen:

li $v0, 4
la $a0, thirteen
syscall


addi $t7, $t7, -1
j printhex

printfourteen:

li $v0, 4
la $a0, fourteen
syscall


addi $t7, $t7, -1
j printhex

printfifteen:

li $v0, 4
la $a0, fifteen
syscall

addi $t7, $t7, -1
j printhex
########################################
#####################################
nop # This is NOP to help Assembler to work correctly is not necessary

conv_ToDEC:  # convert the value from string to integer

li $s1, 10   # 10 stored in $s1
li $t0, 0    # result in $t0
#li $s0, 2

j conv_loop

conv_loop:  # FOR THE ALGORITHM LOOK TO THE LINE 583!

lb $t3, fBuffer($s0)    # load char from fBuffer
beqz $t3, cont_read_dec # when you find terminator STOP!  
addi $t3, $t3, -48      # ASCII sub 'X' - '0'
mul $t0, $t0, $s1       # Result * 10 
add $t0, $t0, $t3       # (Result * 10) + ('X' - '0')
addi $s0, $s0, 1        # increment the counter 

j conv_loop

nop   # This is NOP to help Assembler to work correctly is not necessary 


CopytoBuffer1:  # Just Copy Paste Data from one buffer to the another buffer

li $s0, 0  # counter
li $s1, 4  # counter for fBuffer \\ starts from 2 to skip the SPACE

copy_loop: # LOOP here for copy

lb $t3, fBuffer($s1)  # get from file Buffer 
beqz $t3, continue_1  # if you find terminator STOP
sb $t3, buffer($s0)   # paste to the main buffer
addi $s1, $s1, 1      # inc counter
addi $s0, $s0, 1      # inc counter

j copy_loop           # loop here


CopytoBuffer2:   # same with above 

li $s0, 0
li $s1, 4

copy_loop0:

lb $t3, fBuffer($s1)
beqz $t3, continue_2
sb $t3, buffer($s0)
addi $s1, $s1, 1
addi $s0, $s0, 1

j copy_loop0



FINISH: # BYE BYE!

li $v0, 10
syscall









# CONV ALGO

#int ToInteger(char *digit)     // please note: destination base is 10!
# {
#    int result = 0;

#    while (*digit) {
#        result = (result * 10) + (*digit - '0');
#        digit++;
#    }

#    return result;
# }