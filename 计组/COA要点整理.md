# COA 要点整理

## Chapter 4 Cache Memory

### Computer Memory System overview

#### Key Characteristics of Computer Memory Systems

**location**: refers to whether memory is internal or external to the computer.

​	The processor requires its own local memory, in the form of registers

​	“Cache is another form of internal memory.” 

​	“External memory consists of peripheral storage devices, such as disk and tape”

**capacity**

​	For internal memory, this is typically expressed in terms of bytes (1 byte = 8 bits) or words. Common word lengths are 8, 16, and 32 bits. External memory capacity is typically expressed in terms of bytes.

**unit of transfer**: For internal memory, the unit of transfer is equal to the number of electrical lines into and out of the memory module. This may be equal to the word length, but is often larger. There are related concepts:

​	Word: The “natural” unit of organization of memory.The size of a word is typically equal to the number of bits used to represent an integer and to the instruction length. BUT there are many exceptions.

​	Addressable units: In some systems, the addressable unit is the word. Others allow addressing at the byte level. In any case, the relationship between the length in bits A of an address and the number N of addressable units is $2^A = N$​.

​	Unit of transfer: For main memory, this is the number of bits read out of or written into memory at a time. Sometimes read and write have different unit of transfer (see Problem 4.23). The unit of transfer need not equal a word or an addressable unit. For external memory, data are often transferred in much larger units than a word, and these are referred to as blocks.

**method of accessing**

sequential access: 

- Memory is organized into units of data, called records. Access must be made in a specific linear sequence.
- A shared read–write mechanism is used
- highly variable access time
- e.g. tape

direct access:

- shared read-write mechanism
- Access is accomplished by direct access to reach a general vicinity plus sequential searching, counting, or waiting to reach the final location.
- highly variable access time
- e.g. disk units

random access:

- Each addressable location in memory has a unique, physically wired-in addressing mechanism.
- constant access time
- e.g. main memory and some cache systems

associative:

- This is a random access type of memory that enables one to make a comparison of desired bit locations within a word for a specified match, and to do this for all words simultaneously.
- a word is retrieved based on a portion of its contents rather than its address.
- each location has its own addressing mechanism
- constant access time
- e.g. cache

**performance**

access time (latency)

For <u>random-access</u> memory, this is the time it takes to perform a read or write operation, that is, the time from the instant that an address is presented to the memory to the instant that data have been stored or made available for use. For <u>non-random-access</u> memory, access time is the time it takes to position the read–write mechanism at the desired location.

memory cycle time

consists of the access time plus any additional time required before a second access can commence. It's a concept about bus, not processor.

transfer rate

This is the rate at which data can be transferred into or out of a memory unit. For random-access memory, it is equal to 1/(cycle time). For non-random-access memory, the following relationship holds:
$$
T_n = T_A +\frac n R
$$
**physical type**

semiconductor memory, magnetic surface memory, used for disk and tape, and optical and magneto-optical.

**physical characteristics**

volatile: In a volatile memory, information decays naturally or is lost when electrical power is switched off. e.g. some semiconductor memory

nonvolatile: In a nonvolatile memory, information once recorded remains without deterioration until deliberately changed; no electrical power is needed to retain information. e.g. magnetic-surface memories, some semiconductor memory

nonerasable: Nonerasable memory cannot be altered, except by destroying the storage unit. Must be nonvolatile. e.g. ROM (semiconductor)

remark: 

1. External, nonvolatile memory is also referred to as secondary memory or auxiliary memory.
2. A portion of main memory can be used as a buffer to hold data temporarily that is to be read out to disk. Such a technique, sometimes referred to as a disk cache

**oraganization**: refers to the physical arrangement of bits to form words.

#### The  Memory Hierarchy

The relationships between capacity, access time and cost per bit:

- Faster access time, greater cost per bit
- Greater capacity, smaller cost per bit
- Greater capacity, slower access time.

The way out of this dilemma is not to rely on a single memory component or technology, but to employ a memory hierarchy.(考过翻译)

As one goes down the hierarchy, the following occur:  

- Decreasing cost per bit
- Increasing capacity
- Increasing access time
- Decreasing frequency of access of the memory by the processor.

<img src="C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20241120191726679.png" alt="image-20241120191726679" style="zoom: 50%;" />

The basis for the validity of condition (d) is a principle known as **locality of reference**

locality of reference：During the course of execution of a program, memory references by the processor, for both instructions and data, tend to cluster.

remark: 

another definition on p147: principle of locality, which states that data in the vicinity of a referenced word are likely to be referenced in the near future.

and on p158: This principle states that memory references tend to cluster. Over a long period of time, the clusters in use change, but over a short period of time, the processor is primarily working with fixed clusters of memory references.

Consider the following line of reasoning:

- Except for branch and call instructions, which constitute only a small fraction of all program instructions, program execution is sequential. Hence, in most cases, the next instruction to be fetched immediately follows the last instruction fetched.  
- It is rare to have a long uninterrupted sequence of procedure calls followed by the corresponding sequence of returns. Rather, a program remains confined to a rather narrow window of procedure-invocation depth. Thus, over a short period of time references to instructions tend to be localized to a few procedures.  
- Most iterative constructs consist of a relatively small number of instructions repeated many times. For the duration of the iteration, computation is therefore confined to a small contiguous portion of a program.  
- In many programs, much of the computation involves processing data structures, such as arrays or sequences of records. In many cases, success

**Spatial locality** refers to the tendency of execution to involve a number of memory locations that are clustered.这在指令上来说，反映了处理器倾向于访问顺序储存的指令；从数据上来说，反映了程序在访问数据时一般也是顺序的。

**Temporal locality** refers to the tendency for a processor to access memory locations that have been used recently.

如何利用这两条性质：Traditionally, temporal locality is exploited by <u>keeping recently used</u> instruction and data values in cache memory and by exploiting a <u>cache hierarchy.</u> Spatial locality is generally exploited by using <u>larger cache blocks</u> and by incorporating <u>prefetching mechanisms</u> (fetching items of anticipated use) into the cache control logic.

remark: The cache is not usually visible to the programmer or, indeed, <u>to the processor</u>. 缓存对处理器也不可见

### Cache Memory Principles

line size: The length of a line, not including tag and control bits.

tag: Because there are more blocks than lines, an individual line cannot be uniquely and permanently dedicated to a particular block. Thus, each line includes a tag that identifies which particular block is currently being stored.

read operation: (书上这么写的，但是比较简略，答题时可能需要结合具体情景和数字作答)

1. The processor generates the read address (RA) of a word to be read. 
2. If the word is contained in the cache, it is delivered to the processor. 
3. Otherwise, the block containing that word is loaded into the cache, and the word is delivered to the processor. 需要注意的是，另一种经典的架构是，先从mm读到cache，再从cache读到CPU

### Elements of Cache Design

**cache addresses**

virtual memory: In essence, virtual memory is a facility that allows programs to address memory from a logical point of view, without regard to the amount of main memory physically available.

logical cache: A logical cache, also known as a virtual cache, stores data using virtual addresses. advantage: faster access. The processor accesses the cache directly, without going through the MMU. disadvantage: most virtual memory systems supply each application with the same virtual memory address space. That is, each application sees a virtual memory that starts at address 0. Thus, the same virtual address in two different applications refers to two different physical addresses. The cache memory must therefore be completely flushed with each application context switch, or extra bits must be added to each line of the cache to identify which virtual address space this address refers to. 就是不同应用使用的虚拟地址都一样（从0开始），那么cache中同一个虚拟地址可能实际对应两个物理地址。解决办法是，要么在切换应用的时候清空cache，要么就增加区分比特。

A physical cache stores data using main memory physical addresses.

![image-20241120193938034](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20241120193938034.png)

**cache size**

希望cache尽量小，这样单价就接近mm；又希望cache尽量大，这样访问速度就接近cache。cache越大，访问速度越慢。

**mapping function**

direct mapping

- simplest
- each block of main memory map into only one possible cache line
- cache line number = main memory block number <u>modulo</u> number of lines in the cache
- For purposes of cache access, each main memory address can be viewed as consisting of three fields: tag, line, word
- disadvatage: if a program happens to reference words repeatedly from two different blocks that map into the same line, then the blocks will be continually swapped in the cache, and the hit ratio will be low (thrashing)

associative mapping

- permit each main memory block to be loaded into any line of the cache
- tag + word field
- 注意，从associative mapping的地址中看不出cache中的line数
- disadvatage: the complex circuitry required to examine the tags of all cache lines in parallel.

set-associative mapping

- As with associative mapping, each word maps into multiple cache lines in a specific set.
- a k way set-associative cache can be physically implemented as v associative caches or k direct mapping caches (small value of k)
- Tag, Set, and Word.
- k = 1 reduce to direct mapping, v = 1 reduce to associative mapping

**replacement algorithm**

To achieve high speed, such an algorithm must be implemented in hardware.

least recently used (LRU): Replace that block in the set that has been in the cache longest with no reference to it. 对于2路组映射，只需要设置一个USE bit，对于全关联映射，可以维护一个表，maintains a separate list of indexes to all the lines in the cache. When a line is referenced, it moves to the front of the list. For replacement, the line at the back of the list is used.

first-in-first-out (FIFO): Replace that block in the set that has been in the cache longest. FIFO is easily implemented as a round-robin or circular buffer technique.

least frequently used (LFU): Replace that block in the set that has experienced the fewest references. LFU could be implemented by associating a counter with each line.

random replacement

**write policy**

两个问题：

1. 在多设备共享访问主存时，cache改了内存中的一个内容但没更新，可能导致其他访问同一块内存的设备得到无效数据；反过来，一个设备修改mm可能导致cache中的内容失效
2. 多处理器多cache情况下，一个cache中的内存更改可能导致其他cache中的内容失效

解决第一个问题

write through

- all write operations are made to main memory as well as to the cache, ensuring that main memory is always valid.
- disadvantage: it generates substantial memory traffic and may create a bottleneck.
- simplest

write back

- minimize memory writes
- With write back, updates are made only in the cache. When an update occurs, a dirty bit, or use bit, associated with the line is set. Then, when a block is replaced, it is written back to main memory if and only if the dirty bit is set.
- disadvantage: portions of main memory are invalid, and hence accesses by I/O modules can be allowed only through the cache. This makes for complex circuitry and a potential bottleneck. 因为如果IO直接访问mm则有可能这块mm已经在cache中被修改了只不过没写回，是无效的。

解决第二个问题

bus watching with write through: Each cache controller monitors the address lines to detect write operations to memory by other bus masters. If another master writes to a location in shared memory that also resides in the cache memory, the cache controller invalidates that cache entry. only for write through.

Hardware transparency: if one processor modifies a word in its cache, this update is written to main memory. In addition, any matching words in other caches are similarly updated.

Noncacheable memory: Only a portion of main memory is shared by more than one processor, and this is designated as noncacheable. In such a system, all accesses to shared memory are cache misses, because the shared memory is never copied into the cache.

**line size**

As the block size increases from very small to larger sizes, the hit ratio will at first increase because of the principle of locality. The hit ratio will begin to decrease, however, as the block becomes even bigger and the probability of using the newly fetched information becomes less than the probability of reusing the information that has to be replaced. Two specific effects come into play

- Larger blocks reduce the number of blocks that fit into a cache. Because each block fetch overwrites older cache contents, a small number of blocks results in data being overwritten shortly after they are fetched.
- As a block becomes larger, each additional word is farther from the requested word and therefore less likely to be needed in the near future.

**number of caches**

includes: multilevel cache and split cache

multilevel caches

background: on-chip cache is faster than external bus(这里的external是相对于processor而言的，其external指的是片外cache和mm等，而不是普通意义上的外设), and saves external bus for other transfer.

那么片外cache是不是没用了呢？不是。由此引入经典的两级cache，L1在片上，L2在片外

Two features of contemporary cache design for multilevel caches are noteworthy

- First, for an off-chip L2 cache, many designs do not use the system bus as the path for transfer between the L2 cache and the processor, but <u>use a separate data path</u>, so as to reduce the burden on the system bus. 
- Second, with the continued shrinkage of processor components, a number of processors now <u>incorporate the L2 cache on the processor chip</u>, improving performance.

L2一般在L1两倍大的时候，对命中率的提升最显著

The need for the L2 cache to be larger than the L1 cache to affect performance makes sense. If the L2 cache has the same line size and capacity as the L1 cache, its contents will more or less mirror those of the L1 cache.

unified versus split caches

<u>advantages of a unified cache</u>:  

- For a given cache size, a unified cache has a higher hit rate than split caches because it balances the load between instruction and data fetches automatically. That is, if an execution pattern involves many more instruction fetches than data fetches, then the cache will tend to fill up with instructions, and if an execution pattern involves relatively more data fetches, the opposite will occur.
- Only one cache needs to be designed and implemented.

More recently, it has become common to split the cache into two: one dedicated to instructions and one dedicated to data. These two caches both exist at the same level, typically as two L1 caches.

The key <u>advantage of the split cache</u> design is that it eliminates contention for the cache between the instruction fetch/decode unit and the execution unit. important for pipelining

The trend is toward split caches at the L1 and unified caches for higher levels, particularly for superscalar machines

### appendix 4A

access time for 2-level cache

![image-20241120210920411](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20241120210920411.png)

cost

![image-20241120210957651](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20241120210957651.png)

To get at this, consider the quantity T1/Ts, which is referred to as the **access efficiency**. It is a measure of how close average access time (Ts) is to M1 access time (T1).
$$
\dfrac{T_1}{T_s}=\dfrac{1}{1+(1-H)\frac{T_2}{T_1}}
$$
So if there is strong locality, it is possible to achieve high values of hit ratio even with relatively small upper-level memory size (small Relative memory size (S1/S2)).



## Chapter 12 Instruction Sets: Characteristics and Functions

### Machine Instruction Characteristics

machine instructions or computer instructions: The operation of the processor is determined by the instructions it executes. 

instruction set: The collection of different instructions that the processor can execute

#### elements of a machine instruction

- Operation code
- Source operand reference
- Result operand reference
- Next instruction reference

Source and result operands can be in one of four areas

- Main or virtual memory
- Processor register
- Immediate
- I/O device: If memory-mapped I/O is used, this is just another main or virtual memory address.

#### Instruction Representation

Opcodes are represented by abbreviations, called **mnemonics**, that indicate the operation.

#### Instruction types

A high-level language expresses operations in a concise algebraic form, using variables. A machine language expresses operations in a basic form involving the movement of data to or from registers.

The set of machine instructions must be sufficient to express any of the instructions from a high-level language. With this in mind we can categorize instruction types as follows: 

- Data processing: <u>Arithmetic</u> and <u>logic</u> instructions.  
- Data storage: Movement of data into or out of register and or <u>memory</u> locations.  
- Data movement: <u>I/O</u> instructions.  
- Control: <u>Test</u> and <u>branch</u> instructions.

#### Number of Addresses

The reasoning for the number of addresses:Virtually all arithmetic and logic operations are either unary (one source operand) or binary (two source operands). Thus, <u>we would need a maximum of two addresses to reference source operands</u>. The result of an operation must be stored, suggesting a third address, which defines a destination operand. Finally, after completion of an instruction, the next instruction must be fetched, and its address is needed.

note that zero-address instructions are applicable to a special memory organization called a stack.

tradeoff for number of addresses:“The number of addresses per instruction is a basic design decision. Fewer addresses per instruction result in instructions that are more <u>primitive</u>, requiring a <u>less complex processor</u>. It also results in instructions of <u>shorter length</u>. On the other hand, programs contain more total instructions, which in general results in <u>longer execution times</u> and <u>longer, more complex programs.</u>” 

更重要的是一个门限值：Also, there is an important threshold between one-address and multiple-address instructions. 多地址指令才能允许只依赖于寄存器的操作，这更快。

#### Instruction Set Design

The most important of these fundamental design issues include the following:  

- Operation repertoire: How many and which operations to provide, and how complex operations should be.  
- Data types: The various types of data upon which operations are performed.  
- Instruction format: Instruction length (in bits), number of addresses, size of various fields, and so on.  
- Registers: Number of processor registers that can be referenced by instructions, and their use.  
- Addressing: The mode or modes by which the address of an operand is specified.

### Types of Operands

The most important general categories of data are

- Addressses, in this context, they can be considered to be unsigned integers
- Numbers
- Characters
- Logical data

#### Numbers

“An important distinction between numbers used in ordinary mathematics and numbers stored in a computer is that the latter are limited.” 精度和范围都是有限的。因此，舍入、溢出和下溢出

常见的三种数值数据

■ Binary integer or binary fixed point  

■ Binary floating point  

■ Decimal

**Packed decimal**:压缩BCD码。用四位二进制数表示一个十进制数，而且一般8个8个的使用。比如246=0000 0010 0100 0110

#### Characters

IRA:International Reference Alphabet,referred to in the United States as the American Standard Code for Information Interchange (ASCII)

用7位二进制数表示一个字符，但是一般都用8位字符，多出来的一位要么是0，要么用于奇偶校验。多出来的部分用来表示控制字符，比如控制打印，通信流程等。

还有一种编码字符集Extended Binary Coded Decimal Interchange Code (EBCDIC)，8位，和IRA一样，与packed decimal兼容

#### Logical data

当一个n位单元被视为n个1比特数据（要么是1要么是0）时，这个数据就叫做逻辑数据

优点：

- 存布尔值或二进制数据时，更高效
- 有时候我们希望按位操作数据，这时logical数据更方便

### Types of Operations

■ Data transfer  :most common

■ Arithmetic  

■ Logical  

■ Conversion  

■ I/O  

■ System control  

■ Transfer of control

#### Data transfer

需要明确：

1. 源和目的操作数地址：内存、寄存器或栈
2. 数据长度
3. 寻址方式

“If one or both operands are in memory, then the processor must perform some or all of the following actions: 1. Calculate the memory address, based on the address mode (discussed in Chapter 13). 2. If the address refers to virtual memory, translate from virtual to real memory address. 3. Determine whether the addressed item is in cache. 4. If not, issue a command to the memory module.” 

#### Arithmetic

Most machines also provide a variety of operations for manipulating individual bits of a word or other addressable units, often referred to as “**bit** **twiddling**.” They are based upon Boolean operations

![image-20241225193212488](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20241225193212488.png)

#### Transfer of Controls

为什么控制转移是必须的？因为下述情况/需求存在：

- 循环
- 决策/条件转移
- 模块化编程

“most common transfer-of-control operations found in instruction sets: branch, skip, and procedure call.”

“The two principal reasons for the use of procedures are economy and modularity.” 使用程序的两个主要原因是经济性和模块性。经济性使得编程更轻松、存储空间利用率提高：不然重复写相同的程序很占空间。模块性使得编程更轻松

“Three points are worth noting: 

1. A procedure can be called from more than one location. 
2. A procedure call can appear in a procedure. This allows the nesting of procedures to an arbitrary depth. 
3. Each procedure call is matched by a return in the called program.”

“There are three common places for storing the return address: 

■ Register ![image-20241225194433498](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20241225194433498.png)

■ Start of called procedure ![image-20241225194442226](C:\Users\Leo\AppData\Roaming\Typora\typora-user-images\image-20241225194442226.png)

■ Top of stack:最常见的方式。而且是唯一一种便于重入程序的设计

“A **reentrant procedure** is one in which it is possible to have several calls open to it at the same time. A recursive procedure (one that calls itself) is an example of the use of this feature” 

调用过程时如何传参：使用寄存器或者存在内存中紧跟call指令的位置。仍然，还是使用栈最灵活