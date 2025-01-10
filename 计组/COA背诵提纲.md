Chapter 1

Definition:

- Computer architecture p2
- instruction set architecture (ISA) 
- Computer organization 
- A hierarchical system  p3
- Structure
  - four main structural components (traditional single-processor computer) p4
  - four major structural components of CPU 
- Function 定义总述
  - four basic functions that a computer can perform

Central processing unit (CPU)

Core

Processor

Chapter 4

method of accessing 4个方式的定义p122

performance: 3 definition

physical characteristics: 两对定义

relationship between access time, capacity and cost perbit

memory hierarchy 分为3层，每层是什么，以及实例？

As one goes down the hierarchy, the following occur (4)

principle of locality p125

cache address (2)

methods of mapping (3)

replacement algorithm (4)

write policy (2)

阐述这幅图的理解

首先给出这幅图的主题（自变量，因变量）

4点 

![image-20250108085426354](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108085426354.png)

阐述下面这幅图，先介绍主题，然后insight1点，阐述可能的解释

![image-20250108085900768](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108085900768.png)

Chapter 12

Elements of a Machine Instruction, 4个

操作数的来源和去向4个 p414

指令的4个类型 p416

操作数类型 4个 

Chapter 13

寻址方式7种，优缺点

instruction format 的设计因素两条

allocation of bits影响因素6条

Chapter 14

两种reg在处理器中扮演的角色

user-visible reg 4种

control and status reg 4个实例

解释图

![image-20250108091728891](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108091728891.png)

![image-20250108091744289](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108091744289.png)

![image-20250108091800019](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108091800019.png)

![image-20250108091808062](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108091808062.png)

解释下面这幅图

![image-20250108092259376](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108092259376.png)

branch prediction 5种

解释图

![image-20250108092728808](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108092728808.png)

delayed branch

Chapter 15

key elements shared by most RISC design (3) p537

解释图

环形buffer种有几个windows，现在的指针指在哪里，如果call一个，怎么变化，再call一个，如果重叠怎么变化（N-window register file can hold only N - 1 procedure activations.）

![image-20250108093253057](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108093253057.png)

Characteristics of Reduced Instruction Set Architectures 4点

Delayed branch 定义概念 p557

Loop unrolling 概念

Chapter 16 

ILP 概念 p579

限制ILP的5个因素

fig16.4 填图

reg renaming 定义 p587

为什么延迟分支在超标量计算机出来之后失宠？

Chapter 20

micro-operation 定义

取指阶段的3个时隙，4步微操作，注意PC自增在第二个阶段发生

间址阶段的3个时隙，3步微操作

中断周期的3个时隙，4个微操作

fig20.2 可能考填图

input (4) & output (2)

![image-20250108095203004](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108095203004.png)

![image-20250108095332252](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108095332252.png)

间址时，IR到MAR没有直接的通路，用的是MBR

内部总线结构为什么需要引入Y和Z寄存器：Y是输入时若有两个操作数，用Y更加灵活；Z是不能直接把ALU计算结果输出到总线上

Chapter 21

水平/垂直微指令特点与差别 

下图的执行流程4步

![image-20250108095920849](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108095920849.png)

两个decoder的区别

sequencing 设计时要考虑的2点因素

3种不同的排序方式（按照地址数划分）尤其是变长地址格式的概念以及优点

packing/unpack 概念

horizontal/vertical 概念

hard/ soft 概念

encoding techniques 两种





# 答案

Chapter 1

Definition:

- Computer architecture p2
- instruction set architecture (ISA) 
- Computer organization 
- A hierarchical system  p3
- Structure
  - four main structural components (traditional single-processor computer) p4
  - four major structural components of CPU 
- Function 定义总述
  - four basic functions that a computer can perform

Central processing unit (CPU)

Core

Processor

Chapter 4

method of accessing 4个方式的定义p122

performance: 3 definition

physical characteristics: 两对定义

relationship between access time, capacity and cost perbit

memory hierarchy 分为3层，每层是什么，以及实例？

As one goes down the hierarchy, the following occur (4)

principle of locality p125

cache address (2)

methods of mapping (3)

direct：The simplest technique, known as direct mapping, maps each block of main memory into only one possible cache line.

associative: Associative mapping overcomes the disadvantage of direct mapping by permitting each main memory block to be loaded into any line of the cache

set-associative: For set-associative mapping, each word maps into all the cache lines in a specific set

replacement algorithm (4)

Probably the most effective is least recently used (LRU): Replace that block in the set that has been in the cache longest with no reference to it.

FIFO:Replace that block in the set that has been in the cache longest.

least frequently used (LFU): Replace that block in the set that has experienced the fewest references.

random replacement

write policy (2)

The simplest technique is called write through. Using this technique, all write operations are made to main memory as well as to the cache, ensuring that main memory is always valid.

With write back, updates are made only in the cache. When an update occurs, a dirty bit, or use bit, associated with the line is set. Then, when a block is replaced, it is written back to main memory if and only if the dirty bit is set.s

阐述这幅图的理解

首先给出这幅图的主题（自变量，因变量）

Figure 4.16 shows the results of one simulation study of set-associative cache performance as a function of cache size

4点 

1. The difference in performance between direct and two-way set associative is significant up to at least a cache size of 64 kB. （分不分路数一直很重要）
2. Note also that the difference between two-way and four-way at 4 kB is much less than the difference in going from for 4 kB to 8 kB in cache size. （低缓存容量时，增加路数不如增加总大小）
3. The complexity of the cache increases in proportion to the associativity, and in this case would not be justifiable against increasing cache size to 8 or even 16 kB. （增加路数很难，有时候不经济）
4. A final point to note is that beyond about 32 kB, increase in cache size brings no significant increase in performance.（32KB以后，增加总大小也没什么意义了）

![image-20250108085426354](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108085426354.png)

阐述下面这幅图，先介绍主题，然后insight1点，阐述可能的解释

Figure 4.17 shows the results of one simulation study of two-level cache performance as a function of cache size

The figure shows the impact of L2 on total hits with respect to L1 size. L2 has little effect on the total number of cache hits until it is at least double the L1 cache size. 

If the L2 cache has the same line size and capacity as the L1 cache, its contents will more or less mirror those of the L1 cache.

![image-20250108085900768](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108085900768.png)

Chapter 12

Elements of a Machine Instruction, 4个 p414

- opcode
- source oprand ref.
- result. oprand ref.
- next instr. ref.

操作数的来源和去向4个 p414

- processor reg
- maim/virtual mem
- immediate
- IO device

指令的4个类型 p416

- data proc
- data move
- data storage
- control

操作数类型 4个 

- address
- number
- logical data
- character

Chapter 13

寻址方式7种，优缺点

instruction format 的设计因素两条

- instr. length
- allocation of bits

allocation of bits影响因素6条

- num of oprands
- number of addressing mode
- register or mem
- num of reg set
- addr. range
- addr. granularity

Chapter 14

两种reg在处理器中扮演的角色

user-visible reg 4种

- general purpose
- data
- addr.
- control codes

control and status reg 4个实例:PC,MBR,MAR,IR

解释图

Once an instruction is fetched, its operand specifiers must be identified. Each input operand in memory is then fetched, and this process may require indirect addressing. Register-based operands need not be fetched. Once the opcode is executed, a similar process may be needed to store the result in main memory.

![image-20250108091728891](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108091728891.png)

![image-20250108091744289](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108091744289.png)

![image-20250108091800019](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108091800019.png)

![image-20250108091808062](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108091808062.png)

解释下面这幅图

Figure 14.14a plots the speedup factor as a function of the number of instructions that are executed without a branch. As might be expected, at the limit (n -> ∞), we have a k-fold speedup. 

Figure 14.14b shows the speedup factor as a function of the number of stages in the instruction pipeline. In this case, the speedup factor approaches the number of instructions that can be fed into the pipeline without branches. Thus, the larger the number of pipeline stages, the greater the potential for speedup.

![image-20250108092259376](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108092259376.png)

branch prediction 5种

解释图

![image-20250108092728808](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108092728808.png)

delayed branch

It is possible to improve pipeline performance by automatically rearranging instructions within a program, so that branch instructions occur later than actually desired.

Chapter 15

key elements shared by most RISC design (3) p537

the key elements shared by most designs are these:  

- A large number of general-purpose registers, and/or the use of compiler technology to optimize register usage.  
- A limited and simple instruction set.  
- An emphasis on optimizing the instruction pipeline.

解释图

环形buffer中有几个windows，现在的指针指在哪里，如果call一个，怎么变化，再call一个，如果重叠怎么变化（N-window register file can hold only N - 1 procedure activations.）

The circular organization is shown in Figure 15.2, which depicts a circular buffer of six windows. The buffer is filled to a depth of 4 (A called B; B called C; C called D) with procedure D active. The current-window pointer (CWP) points to the window of the currently active procedure. Register references by a machine instruction are offset by this pointer to determine the actual physical register. The saved-window pointer (SWP) identifies the window most recently saved in memory. If procedure D now calls procedure E, arguments for E are placed in D’s temporary registers (the overlap between w3 and w4) and the CWP is advanced by one window. If procedure E then makes a call to procedure F, the call cannot be made with the current status of the buffer. This is because F’s window overlaps A’s window. If F begins to load its temporary registers, preparatory to a call, it will overwrite the parameter registers of A (A.in). Thus, when CWP is incremented (modulo 6) so that it becomes equal to SWP, an interrupt occurs, and A’s window is saved. Only the first two portions (A.in and A.loc) need be saved. Then, the SWP is incremented and the call to F proceeds. A similar interrupt can occur on returns. For example, subsequent to the activation of F, when B returns to A, CWP is decremented and becomes equal to SWP. This causes an interrupt that results in the restoration of A’s window.

![image-20250108093253057](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108093253057.png)

Characteristics of Reduced Instruction Set Architectures 4点

■ One instruction per cycle  ■ Register-to-register operations  ■ Simple addressing modes  ■ Simple instruction formats

Delayed branch 定义概念 p557

Delayed branch, a way of increasing the efficiency of the pipeline, makes use of a branch that does not take effect until after execution of the following instruction (hence the term delayed).

Loop unrolling 概念

Unrolling replicates the body of a loop some number of times called the unrolling factor (u) and iterates by step u instead of step 1.

Chapter 16 

ILP 概念 p579

The term instruction-level parallelism refers to the degree to which, on average, the instructions of a program can be executed in parallel

限制ILP的5个因素

■ True data dependency;  ■ Procedural dependency;  ■ Resource conflicts;  ■ Output dependency;  ■ Antidependency.

fig16.4 填图

reg renaming 定义 p587

When a new register value is created (i.e., when an instruction executes that has a register as a destination operand), a new register is allocated for that value. Subsequent instructions that access that value as a source operand in that register must go through a renaming process: the register references in those instructions must be revised to refer to the register containing the needed value.

为什么延迟分支在超标量计算机出来之后失宠？

The reason is that multiple instructions need to execute in the delay slot, raising several problems relating to instruction dependencies.

Chapter 20

micro-operation 定义

In fact, we will see that each of the smaller cycles involves a series of steps, each of which involves the processor registers. We will refer to these steps as micro-operations.

取指阶段的3个时隙，4步微操作，注意PC自增在第二个阶段发生

间址阶段的3个时隙，3步微操作

中断周期的3个时隙，4个微操作

fig20.2 可能考填图

input (4) & output (2)

in: clock, IR, control signal from control bus, flags

out: control signal within processor, to control bus

![image-20250108095203004](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108095203004.png)

![image-20250108095332252](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108095332252.png)

间址时，IR到MAR没有直接的通路，用的是MBR

内部总线结构为什么需要引入Y和Z寄存器：Y是输入时若有两个操作数，用Y更加灵活；Z是不能直接把ALU计算结果输出到总线上

These are needed for the proper operation of the ALU. When an operation involving two operands is performed, one can be obtained from the internal bus, but the other must be obtained from another source. Register Y provides temporary storage for the other input

Register Z provides temporary output storage.

Chapter 21

水平/垂直微指令特点与差别 

Horizontal: There is one bit for each internal processor control line and one bit for each system bus control line.

In a vertical microinstruction, a code is used for each action to be performed [e.g., MAR d (PC)], and the decoder translates this code into individual control signals.

下图的执行流程4步

1. To execute an instruction, the sequencing logic unit issues a READ command to the control memory.  
2. The word whose address is specified in the control address register is read into the control buffer register.  3
3. The content of the control buffer register generates control signals and next-address information for the sequencing logic unit.  
4. The sequencing logic unit loads a new address into the control address register based on the next-address information from the control buffer register and the ALU flags.

![image-20250108095920849](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20250108095920849.png)

两个decoder的区别

The upper decoder translates the opcode of the IR into a control memory address. The lower decoder translates the code into individual control signals.

sequencing 设计时要考虑的2点因素

Two concerns are involved in the design of a microinstruction sequencing technique: the size of the microinstruction and the address-generation time.

3种不同的排序方式（按照地址数划分）尤其是变长地址格式的概念以及优点

变长：One bit designates which format is being used. In one format, the remaining bits are used to activate control signals. In the other format, some bits drive the branch logic module, and the remaining bits provide the address.

packing/unpack 概念

The degree of packing relates to the degree of identification between a given control task and specific microinstruction bits. As the bits become more packed, a given number of bits contains more information

horizontal/vertical 概念

The terms horizontal and vertical relate to the relative width of microinstructions.

hard/ soft 概念

The terms hard and soft microprogramming are used to suggest the degree of closeness to the underlying control signals and hardware layout.

encoding techniques 两种

The functional encoding method identifies functions within the machine and designates fields by function type.

Resource encoding views the machine as consisting of a set of independent resources and devotes one field to each (e.g., I/O, memory, ALU).