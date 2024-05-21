# Random word problem by groovemonkey

## Background
Since there are a lot of bugs in the original code and I did not trust the results shown in the [video](https://www.youtube.com/watch?v=ICZKZQowiHs) where Elixir and Go are compared, I tried to fix the code on my own, respecting the "bad" approach of generating a long word and checking afterwards if it is unique.

Clearly, this was designed to have bigger load on the CPU both in Go and Elixir.

#### Benchmark #1

Specs
```
Operating System: Linux
CPU Information: AMD Ryzen 7 3700X 8-Core Processor
Number of Available Cores: 16
Available memory: 15.58 GB
Elixir 1.16.2
Erlang 26.2.4
JIT enabled: true
```

I first of all fixed the code and used a different approach on checking on uniqueness. Already used words are stored in a map for the `n_words` runs. All the `n_words_vec` runs are similar to the original code, resulting in **O(n^2)**

```
Name                     ips        average  deviation         median         99th %
5_words_vec        598807.57        1.67 μs  ±1126.75%        1.51 μs        2.48 μs
5_words            454714.77        2.20 μs   ±384.67%           2 μs        3.36 μs
55_words_vec        40032.28       24.98 μs    ±45.18%       23.66 μs       56.15 μs
55_words            28917.33       34.58 μs    ±53.73%       32.41 μs       85.02 μs
555_words            3438.48      290.83 μs    ±19.17%      278.58 μs      440.64 μs
555_words_vec         948.92     1053.83 μs     ±8.66%     1039.36 μs     1283.28 μs
5555_words            277.31     3606.08 μs    ±12.80%     3434.62 μs     4846.96 μs
5555_words_vec          8.17   122351.74 μs     ±7.81%   119250.35 μs   154309.15 μs

Comparison: 
5_words_vec        598807.57
5_words            454714.77 - 1.32x slower +0.53 μs
55_words_vec        40032.28 - 14.96x slower +23.31 μs
55_words            28917.33 - 20.71x slower +32.91 μs
555_words            3438.48 - 174.15x slower +289.16 μs
555_words_vec         948.92 - 631.04x slower +1052.16 μs
5555_words            277.31 - 2159.35x slower +3604.41 μs
5555_words_vec          8.17 - 73265.15x slower +122350.07 μs
```

As you see, somewhere between `n=55` and `n=555`, `n_words` is faster than `n_words_vec` approach.

When respecting the original algorithm, we get extremly bad performance

```
Name                     ips        average  deviation         median         99th %
5_words_vec        610614.38        1.64 μs   ±791.40%        1.52 μs        2.27 μs
5_words            509761.89        1.96 μs  ±1227.27%        1.81 μs        3.06 μs
55_words_vec        34057.32       29.36 μs    ±68.52%       26.74 μs       73.04 μs
55_words            24407.22       40.97 μs    ±73.41%       37.42 μs      105.33 μs
555_words            3611.05      276.93 μs    ±17.16%      265.68 μs      371.89 μs
555_words_vec         899.48     1111.76 μs     ±9.18%     1093.24 μs     1560.43 μs
5555_words            274.97     3636.80 μs    ±15.72%     3608.64 μs     5499.74 μs
5_words_org           254.13     3934.98 μs    ±36.14%     3595.50 μs    10436.87 μs
55_words_org           20.21    49469.37 μs    ±22.62%    47242.96 μs   115424.63 μs
5555_words_vec          8.47   118055.15 μs     ±4.66%   117274.67 μs   144730.58 μs
555_words_org           1.27   788335.86 μs    ±62.53%   547814.93 μs  1683027.39 μs
1000_words_org         0.189  5297031.37 μs   ±120.51%  2320623.91 μs 12624979.20 μs
1500_words_org        0.0526 19021030.08 μs     ±0.00% 19021030.08 μs 19021030.08 μs
```

`1500_words_org` needs ~20 s. Compared to `1000_words_org`, which takes 5.3 s, results in `400 %` the time needed for only `50 %` more input length.

A first attempt on using more cores on this failed. I assume it is because of the data being greater than 2 MB that needs to be copied to all processes.
The more I used, the slower it was in total.
Find below all the `async` approaches appended with `_n` where `n` is the amount of processes spawned. `_s` uses the code without spawning a new process. Even if this would give better results, to be fair, an async implementation in Go would be needed for a better comparsion also.

```
Name                          ips          average  deviation           median           99th %
5_words_vec             539757.46          1.85 μs   ±869.64%          1.69 μs          2.79 μs
5_words_vec_fast        508998.06          1.96 μs   ±253.85%          1.83 μs          2.74 μs
5_words                 477332.00          2.09 μs   ±383.98%          1.98 μs          2.86 μs
55_words_vec             35297.25         28.33 μs    ±56.63%         26.76 μs         50.92 μs
55_words_vec_fast        29117.23         34.34 μs    ±48.09%         32.54 μs         86.04 μs
55_words                 28316.01         35.32 μs    ±46.95%         33.69 μs         85.49 μs
555_words_vec_fast        3342.34        299.19 μs    ±14.63%        285.58 μs        437.33 μs
555_words                 3330.41        300.26 μs    ±19.25%        290.56 μs        405.91 μs
555_words_vec              925.35       1080.68 μs     ±9.95%       1062.71 μs       1445.89 μs
5555_words_vec_fast        303.96       3289.93 μs     ±9.79%       3241.49 μs       4544.45 μs
5555_words                 288.83       3462.25 μs     ±9.03%       3390.70 μs       4318.47 μs
5_words_org                173.14       5775.63 μs    ±15.56%       5706.72 μs       7817.02 μs
55_words_org                22.85      43766.04 μs    ±16.14%      41165.59 μs      87246.76 μs
555_words_org_1_s           19.57      51103.57 μs    ±14.65%      51379.56 μs     104355.96 μs
555_words_org_1             18.41      54320.57 μs     ±9.61%      53484.89 μs      71125.89 μs
555_words_org_2             13.37      74772.24 μs    ±12.16%      73016.79 μs     110578.85 μs
555_words_org_4             10.24      97635.89 μs    ±10.22%      96212.53 μs     129614.35 μs
5555_words_vec               8.40     118983.93 μs     ±4.34%     119492.91 μs     133392.27 μs
555_words_org_8              5.61     178312.62 μs    ±10.65%     176747.08 μs     226669.52 μs
555_words_org_16             2.37     421485.33 μs     ±7.84%     416130.98 μs     479112.28 μs
555_words_org                1.54     650177.28 μs    ±59.48%     464474.46 μs    1413622.01 μs
1000_words_org              0.163    6131361.22 μs     ±0.00%    6131361.22 μs    6131361.22 μs
1500_words_org            0.00260  384357233.75 μs     ±0.00%  384357233.75 μs  384357233.75 μs
```
The fastest approach for `n=5555` was `5555_words_vec_fast` being two times faster than the original approach with `n=5` words (`5_words_org` - with fixed code, obviously).

Even though I tried to keep the benchmark as close to the original as possible, I needed to fix some parts here and there. So comparing this results to the original ones will no make much sense. Maybe comparing it with a similar Go implementation running on the same system brings clarity. At the end, comparing this languages does not make any sense at all to me, even though it was fun implementing the shown approaches.

A daring comparsion, getting a feeling about the magnitude of the Go implementation being faster than Elixir one, could come from the following.

Buggy original code ran `1.7x` slower on my system than on the creator's system.
Average runtime of `array_5555_words` was `740,000 ns` on creator's system.
Average runtime of `Benchmark5555Words-12` was `175,125 ns` on creator's system.
Average runtime of `5555_words_vec_fast` was `3289.93 µs` or `3,289,930 ns` on my system.

Assuming that Go code also runs `1.7x` slower on my system, this would result in 
`175,125 ns * 1.7 = 297,712 ns` or 

`~300 µs` (Go)
vs 
 `3,300 µs` (`3,289.93 µs`)

which means the Elixir implementation is `11 times` slower than the Go one.

At the end, imho, this value is useless, but gives a better idea on what is possible with Elixir.