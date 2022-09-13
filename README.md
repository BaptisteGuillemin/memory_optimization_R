# memory_optimization_R
This repository is sum up to methods, functions, library I used for memory optimization in R. In this document there is list of tools and bibliographie for profiling memory in R

Useful links :
•	Benchmarking memory tracking methods in Rstudio
https://stt4230.rbind.io/amelioration_code/optim_temps_r/#fonctions-rprof-et-summaryrprof
https://bench.r-lib.org/
•	Names & values: https://adv-r.hadley.nz/names-values.html
•	Measuring performance: https://adv-r.hadley.nz/perf-measure.html
•	Improving performance: https://adv-r.hadley.nz/perf-improve.html
•	Object size (memory usage): http://adv-r.had.co.nz/memory.html
•	Profvis: https://rstudio.github.io/profvis/ 
 https://rstudio.github.io/profvis/faq.html


•	We can use interface in order to track the use of memory of the algorithm. Or htop on a linux environment.

•	Garbage collection gc(): R is language that’s deallocate memory according every sample of time. The gc() function force R to collect the garbage. The argument full, when is TRUE is also useful because it forces the garbage collector to collect not only the recent garbages.
In addition gctorture() provide a tool that automate garbage collection at every memory allocation, unfortunately it slow down R a lot. Beside gc(info=TRUE) give every de allocation of memory during the execution of the script.
Despite what I read in many documentations, what I profile about gc() with other functions to test its efficiency and what seemed to make sense; force the garbage collection is actually helpful sometimes.

•	Package pryr :
-	mem_used() : will help you understand how R allocates and frees memory. It is helpful to track one line of code but doesn’t seem so accurate. In my research I notice that force the garbage collection was actually allocating memory more than deallocation using mem_used.
-	mem_change(): The second one was helpful when removing object along the code, it show me how much memory I was freeing. Although, and as always, this function is not accurate sometimes for example with the gc() function.

•	lineprof package: provide line by line code tracking of memory and time. Lineprof is not very handy to use because it works with a script saved. This package rely on Rprof method and doesn’t really bring something more than what I had with Rprof.

•	Proftools package: just like the previous package mention. It’s more useful for time complexity tracking even if some functions have a memory parameter it doesn’t much info. The package was created to provide graphs and make clearer the ouput of Rprof function. 
In my case these graphs were difficult to interpret as the code was quite long with functions calling other functions with double loop. I made a proftools markdown with example.

•	Modification in place: R sometimes create unnecessary copies of objects. Understanding when objects are copied is important for writing efficient R code.
-	tracemen(): return the address in the memory, by comparing with another object the logical indicator TRUE, i.e. both data objects have the same memory address.
-	Adress() : get the rmemory address in the CPU and allows to check if there is an object is saved in different locations
-	Ref() : count the number of reference of memory adresses foir an object. Ref() is like address() but more straight forward to use when profiling memory.
I used this function when trying to optimize the code. They are useful to profile one by one line of code, to check every object associated with object size to make sur there is no unwanted copies and useless memory allocation.

•	library(pryr): to understand memory usage in R, we will start with
-	 object_size(): This function tells you how many bytes of memory an object occupies.
-	mem_change(): Check the memory difference before and after a line of code. It can be useful to check with a rm() how much memory the command is de allocating. 

•	Librairy Bench: The function mark is really clear to interpret and seems accurate compare to the rest of the tools I found, but has a big limitation: works only for 2 equivalent functions. A script with an example, a function to return the output in a more easy way to interpret.

•	Rprof method: runs the profiler for performance of analysis of R code associated with summaryRprof() summarizes the output of Rprof() and gives percent of time spent in each function (with two types of normalization) that are called inside the library. This method was very valuable for this reason. Resulting in every memory allocation of the code from within the source code.

•	Package profvis: visualization tools from the fonction Rprof(). This method creates a flame graph and data graph from the Rprof output. Although, there is a drawback with this method. Indeed, it use a lot of memory/processing. On the other hand, we can see precisely what is happening with the flame graph and this solution is the best for profiling the whole library in one time. The best advantage is that profvis enable to profile inside of the library. I wrote down a script as tutorial. Interpreting profvis is not an easy task because of lazzy evaluation the memory is used later than the line of code which actually using it.
