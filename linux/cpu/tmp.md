12 | 套路篇：CPU 性能优化的几个思路

- 1.怎么判断它是不是有效呢？特别是优化后，到底能提升多少性能呢？
- 2.如果有多个性能问题同时发生，你应该先优化哪一个呢？
- 3.当有多种方法可以选择时，你会选用哪一种呢？是不是总选那个最大程度提升性能的方法就行了呢？

对系统的性能指标进行量化，并且要分别测试出优化前、后的性能指标，用前后指标的变化来对比呈现效果。性能的量化指标有很多，比如 CPU 使用率、应用程序的吞吐量、客户端请求的延迟等。指标**不要局限在单一维度的指标上**，你至少要从应用程序和系统资源这两个维度，分别选择不同的指标。比如，以 Web 应用为例：

- 应用程序的维度，我们可以用**吞吐量和请求延迟**来评估应用程序的性能。
- 系统资源的维度，我们可以用 **CPU 使用率**来评估系统的 CPU 使用情况。

80% 的问题都是由 20% 的代码导致的。只要找出这 20% 的位置，你就可以优化 80% 的性能。所以，**并不是所有的性能问题都值得优化**。那关键就在于，怎么判断出哪个性能问题最重要。你可以挨个分析，分别找出它们的瓶颈。

但要注意，现实情况要考虑的因素却没那么简单。最直观来说，**性能优化并非没有成本**。性能优化通常会带来复杂度的提升，降低程序的可维护性，还可能在优化一个指标时，引发其他指标的异常。也就是说，很可能你优化了一个指标，另一个指标的性能却变差了。

## CPU 优化

### 应用程序优化

首先，从应用程序的角度来说，降低 CPU 使用率的最好方法当然是，排除所有不必要的工作，只保留最核心的逻辑。比如减少循环的层次、减少递归、减少动态内存分配等等。

- **编译器优化**
- **算法优化**
- **异步处理**：使用异步处理，可以避免程序因为等待某个资源而一直阻塞，从而提升程序的并发处理能力。
- **多线程代替多进程**：降低上下文切换的成本。
- **善用缓存**

### 系统优化

- **CPU 绑定**：把进程绑定到一个或者多个 CPU 上，可以提高 CPU 缓存的命中率，减少跨 CPU 调度带来的上下文切换问题。
- **CPU 独占**：跟 CPU 绑定类似，进一步将 CPU 分组，并通过 CPU 亲和性机制为其分配进程。这样，这些 CPU 就由指定的进程独占，换句话说，不允许其他进程再来使用这些 CPU。
- **优先级调整**：适当降低非核心应用的优先级，增高核心应用的优先级，可以确保核心应用得到优先处理。
- **为进程设置资源限制**：使用 Linux cgroups 来设置进程的 CPU 使用上限，可以防止由于某个应用自身的问题，而耗尽系统资源。
- **中断负载均衡**：无论是软中断还是硬中断，它们的中断处理程序都可能会耗费大量的 CPU。开启 irqbalance 服务或者配置 smp_affinity，就可以把中断处理过程自动负载均衡到多个 CPU 上。

## 千万避免过早优化

“过早优化是万恶之源”，一方面，优化会带来复杂性的提升，降低可维护性；另一方面，需求不是一成不变的。针对当前情况进行的优化，很可能并不适应快速变化的新需求。这样，在新需求出现时，这些复杂的优化，反而可能阻碍新功能的开发。