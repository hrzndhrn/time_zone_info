# Benchmark: TimeZoneDatabase

This benchmark compares `TimeZoneInfo` with
[`Tzdata`](https://github.com/lau/tzdata) and
[`Tz`](https://github.com/mathieuprog/tz).

The `TimeZoneInfo` will be tested in three different configurations.
Each version uses a different strategy to keep the data available.
- `time_zone_info_pst` is using
  [`:persistent_term`](https://erlang.org/doc/man/persistent_term.html)
- `time_zone_info_ets` is using `:ets`
  [(Erlang Term Storage)](https://erlang.org/doc/man/ets.html)
- `time_zone_info_map` is using a `GenServer` with a `Map` as state. This
  version isn't an available configuration in `TimeZoneInfo`. The
  `GenServer` version is otherwise only used in the tests.

All testees have an implementation for `TimeZoneDatabas`. For the benchmark,
each of them calls the function
`TimeZoneDatabase.time_zone_periods_from_wall_datetime/2`.

The inputs for every benchmark run:
- **ok:** 333 `(datetime, time_zone)` arguments that are resulting in a
  `:ok` return value.
- **gap:** 333 `(datetime, time_zone)` arguments that are resulting in a
  `:gap` return tuple.
- **ambiguous:** 333 `(datetime, time_zone)` arguments that are resulting in
  a `:ambiguous` return tuple.
- **ok_gap_ambiguous:** **ok**, **gap**, and **ambiguous** together.
- **last_year:** 333 `(datetime, time_zone)` arguments with random time zone
  and a date time from now to one year in the past. The data is calculated
  once for all test candidates.
- **berlin_gap_2020**: 333 gaps in the time zone `Europe/Berlin` in 2020.
- **berlin_ambiguous_2020**: 333 ambiguous date time in the time zone
  `Europe/Berlin` in 2020.

The inputs **ok**, **gap**, and **ambiguous** containing random time zones
and date times between 1900 and 2050.

## System

Benchmark suite executing on the following system:

<table style="width: 1%">
  <tr>
    <th style="width: 1%; white-space: nowrap">Operating System</th>
    <td>macOS</td>
  </tr><tr>
    <th style="white-space: nowrap">CPU Information</th>
    <td style="white-space: nowrap">Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz</td>
  </tr><tr>
    <th style="white-space: nowrap">Number of Available Cores</th>
    <td style="white-space: nowrap">8</td>
  </tr><tr>
    <th style="white-space: nowrap">Available Memory</th>
    <td style="white-space: nowrap">16 GB</td>
  </tr><tr>
    <th style="white-space: nowrap">Elixir Version</th>
    <td style="white-space: nowrap">1.10.2</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">22.3</td>
  </tr>
</table>

## Configuration

Benchmark suite executing with the following configuration:

<table style="width: 1%">
  <tr>
    <th style="width: 1%">:time</th>
    <td style="white-space: nowrap">10 s</td>
  </tr><tr>
    <th>:parallel</th>
    <td style="white-space: nowrap">1</td>
  </tr><tr>
    <th>:warmup</th>
    <td style="white-space: nowrap">2 s</td>
  </tr>
</table>

## Statistics


__Input: ambiguous__

Run Time
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">423.60</td>
    <td style="white-space: nowrap; text-align: right">2.36 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.96%</td>
    <td style="white-space: nowrap; text-align: right">2.28 ms</td>
    <td style="white-space: nowrap; text-align: right">3.13 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">187.41</td>
    <td style="white-space: nowrap; text-align: right">5.34 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.86%</td>
    <td style="white-space: nowrap; text-align: right">5.20 ms</td>
    <td style="white-space: nowrap; text-align: right">7.17 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">142.26</td>
    <td style="white-space: nowrap; text-align: right">7.03 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.33%</td>
    <td style="white-space: nowrap; text-align: right">6.64 ms</td>
    <td style="white-space: nowrap; text-align: right">10.45 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">127.21</td>
    <td style="white-space: nowrap; text-align: right">7.86 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.64%</td>
    <td style="white-space: nowrap; text-align: right">7.73 ms</td>
    <td style="white-space: nowrap; text-align: right">9.12 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">105.36</td>
    <td style="white-space: nowrap; text-align: right">9.49 ms</td>
    <td style="white-space: nowrap; text-align: right">±14.52%</td>
    <td style="white-space: nowrap; text-align: right">9.16 ms</td>
    <td style="white-space: nowrap; text-align: right">15.43 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap;text-align: right">423.60</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">187.41</td>
    <td style="white-space: nowrap; text-align: right">2.26x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">142.26</td>
    <td style="white-space: nowrap; text-align: right">2.98x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">127.21</td>
    <td style="white-space: nowrap; text-align: right">3.33x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">105.36</td>
    <td style="white-space: nowrap; text-align: right">4.02x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.94 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">3.41 MB</td>
    <td>3.63x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.36 MB</td>
    <td>3.57x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">2.61 MB</td>
    <td>2.78x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.71 MB</td>
    <td>1.82x</td>
  </tr>
</table>
<hr/>

__Input: berlin_ambiguous_2020__

Run Time
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2018.57</td>
    <td style="white-space: nowrap; text-align: right">0.50 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.07%</td>
    <td style="white-space: nowrap; text-align: right">0.48 ms</td>
    <td style="white-space: nowrap; text-align: right">0.64 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1922.45</td>
    <td style="white-space: nowrap; text-align: right">0.52 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.07%</td>
    <td style="white-space: nowrap; text-align: right">0.50 ms</td>
    <td style="white-space: nowrap; text-align: right">0.75 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">347.77</td>
    <td style="white-space: nowrap; text-align: right">2.88 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.05%</td>
    <td style="white-space: nowrap; text-align: right">2.84 ms</td>
    <td style="white-space: nowrap; text-align: right">3.49 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">266.29</td>
    <td style="white-space: nowrap; text-align: right">3.76 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.40%</td>
    <td style="white-space: nowrap; text-align: right">3.72 ms</td>
    <td style="white-space: nowrap; text-align: right">4.56 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">89.93</td>
    <td style="white-space: nowrap; text-align: right">11.12 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.66%</td>
    <td style="white-space: nowrap; text-align: right">10.94 ms</td>
    <td style="white-space: nowrap; text-align: right">12.98 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap;text-align: right">2018.57</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">1922.45</td>
    <td style="white-space: nowrap; text-align: right">1.05x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">347.77</td>
    <td style="white-space: nowrap; text-align: right">5.8x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">266.29</td>
    <td style="white-space: nowrap; text-align: right">7.58x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">89.93</td>
    <td style="white-space: nowrap; text-align: right">22.45x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.107 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.31 MB</td>
    <td>2.91x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">3.09 MB</td>
    <td>28.85x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.12 MB</td>
    <td>29.16x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.33 MB</td>
    <td>12.38x</td>
  </tr>
</table>
<hr/>

__Input: berlin_gap_2020__

Run Time
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2010.23</td>
    <td style="white-space: nowrap; text-align: right">0.50 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.20%</td>
    <td style="white-space: nowrap; text-align: right">0.49 ms</td>
    <td style="white-space: nowrap; text-align: right">0.63 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">778.46</td>
    <td style="white-space: nowrap; text-align: right">1.28 ms</td>
    <td style="white-space: nowrap; text-align: right">±14.12%</td>
    <td style="white-space: nowrap; text-align: right">1.23 ms</td>
    <td style="white-space: nowrap; text-align: right">2.17 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">258.95</td>
    <td style="white-space: nowrap; text-align: right">3.86 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.67%</td>
    <td style="white-space: nowrap; text-align: right">3.76 ms</td>
    <td style="white-space: nowrap; text-align: right">5.47 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">224.24</td>
    <td style="white-space: nowrap; text-align: right">4.46 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.02%</td>
    <td style="white-space: nowrap; text-align: right">4.36 ms</td>
    <td style="white-space: nowrap; text-align: right">5.60 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">17.76</td>
    <td style="white-space: nowrap; text-align: right">56.32 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.91%</td>
    <td style="white-space: nowrap; text-align: right">55.24 ms</td>
    <td style="white-space: nowrap; text-align: right">68.33 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap;text-align: right">2010.23</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">778.46</td>
    <td style="white-space: nowrap; text-align: right">2.58x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">258.95</td>
    <td style="white-space: nowrap; text-align: right">7.76x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">224.24</td>
    <td style="white-space: nowrap; text-align: right">8.96x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">17.76</td>
    <td style="white-space: nowrap; text-align: right">113.22x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.117 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.65 MB</td>
    <td>5.55x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">4.01 MB</td>
    <td>34.22x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.86 MB</td>
    <td>32.92x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">45.86 MB</td>
    <td>391.23x</td>
  </tr>
</table>
<hr/>

__Input: gap__

Run Time
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">247.05</td>
    <td style="white-space: nowrap; text-align: right">4.05 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.28%</td>
    <td style="white-space: nowrap; text-align: right">4 ms</td>
    <td style="white-space: nowrap; text-align: right">5.11 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">140.68</td>
    <td style="white-space: nowrap; text-align: right">7.11 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.63%</td>
    <td style="white-space: nowrap; text-align: right">6.92 ms</td>
    <td style="white-space: nowrap; text-align: right">9.60 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">115.31</td>
    <td style="white-space: nowrap; text-align: right">8.67 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.59%</td>
    <td style="white-space: nowrap; text-align: right">8.45 ms</td>
    <td style="white-space: nowrap; text-align: right">11.34 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">93.02</td>
    <td style="white-space: nowrap; text-align: right">10.75 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.29%</td>
    <td style="white-space: nowrap; text-align: right">10.27 ms</td>
    <td style="white-space: nowrap; text-align: right">14.47 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">18.56</td>
    <td style="white-space: nowrap; text-align: right">53.89 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.59%</td>
    <td style="white-space: nowrap; text-align: right">53.41 ms</td>
    <td style="white-space: nowrap; text-align: right">62.27 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap;text-align: right">247.05</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">140.68</td>
    <td style="white-space: nowrap; text-align: right">1.76x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">115.31</td>
    <td style="white-space: nowrap; text-align: right">2.14x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">93.02</td>
    <td style="white-space: nowrap; text-align: right">2.66x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">18.56</td>
    <td style="white-space: nowrap; text-align: right">13.31x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">1.26 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">3.65 MB</td>
    <td>2.89x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.60 MB</td>
    <td>2.85x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">3.46 MB</td>
    <td>2.74x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">41.53 MB</td>
    <td>32.9x</td>
  </tr>
</table>
<hr/>

__Input: last_year__

Run Time
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">2128.20</td>
    <td style="white-space: nowrap; text-align: right">0.47 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.40%</td>
    <td style="white-space: nowrap; text-align: right">0.45 ms</td>
    <td style="white-space: nowrap; text-align: right">0.65 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">2095.71</td>
    <td style="white-space: nowrap; text-align: right">0.48 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.51%</td>
    <td style="white-space: nowrap; text-align: right">0.46 ms</td>
    <td style="white-space: nowrap; text-align: right">0.63 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">519.46</td>
    <td style="white-space: nowrap; text-align: right">1.93 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.88%</td>
    <td style="white-space: nowrap; text-align: right">1.91 ms</td>
    <td style="white-space: nowrap; text-align: right">2.54 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">388.19</td>
    <td style="white-space: nowrap; text-align: right">2.58 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.99%</td>
    <td style="white-space: nowrap; text-align: right">2.48 ms</td>
    <td style="white-space: nowrap; text-align: right">3.59 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">210.69</td>
    <td style="white-space: nowrap; text-align: right">4.75 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.19%</td>
    <td style="white-space: nowrap; text-align: right">4.65 ms</td>
    <td style="white-space: nowrap; text-align: right">5.93 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap;text-align: right">2128.20</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">2095.71</td>
    <td style="white-space: nowrap; text-align: right">1.02x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">519.46</td>
    <td style="white-space: nowrap; text-align: right">4.1x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">388.19</td>
    <td style="white-space: nowrap; text-align: right">5.48x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">210.69</td>
    <td style="white-space: nowrap; text-align: right">10.1x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.104 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.26 MB</td>
    <td>2.55x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">1.48 MB</td>
    <td>14.25x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">1.57 MB</td>
    <td>15.14x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.46 MB</td>
    <td>14.15x</td>
  </tr>
</table>
<hr/>

__Input: ok__

Run Time
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">821.13</td>
    <td style="white-space: nowrap; text-align: right">1.22 ms</td>
    <td style="white-space: nowrap; text-align: right">±15.80%</td>
    <td style="white-space: nowrap; text-align: right">1.16 ms</td>
    <td style="white-space: nowrap; text-align: right">2.07 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">466.34</td>
    <td style="white-space: nowrap; text-align: right">2.14 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.30%</td>
    <td style="white-space: nowrap; text-align: right">2.08 ms</td>
    <td style="white-space: nowrap; text-align: right">2.82 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">353.98</td>
    <td style="white-space: nowrap; text-align: right">2.83 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.46%</td>
    <td style="white-space: nowrap; text-align: right">2.74 ms</td>
    <td style="white-space: nowrap; text-align: right">3.87 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">272.42</td>
    <td style="white-space: nowrap; text-align: right">3.67 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.13%</td>
    <td style="white-space: nowrap; text-align: right">3.50 ms</td>
    <td style="white-space: nowrap; text-align: right">5.25 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">215.35</td>
    <td style="white-space: nowrap; text-align: right">4.64 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.46%</td>
    <td style="white-space: nowrap; text-align: right">4.54 ms</td>
    <td style="white-space: nowrap; text-align: right">5.93 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap;text-align: right">821.13</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">466.34</td>
    <td style="white-space: nowrap; text-align: right">1.76x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">353.98</td>
    <td style="white-space: nowrap; text-align: right">2.32x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">272.42</td>
    <td style="white-space: nowrap; text-align: right">3.01x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">215.35</td>
    <td style="white-space: nowrap; text-align: right">3.81x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">0.56 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.66 MB</td>
    <td>1.19x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">1.75 MB</td>
    <td>3.15x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">1.65 MB</td>
    <td>2.97x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.33 MB</td>
    <td>2.39x</td>
  </tr>
</table>
<hr/>

__Input: ok_gap_ambiguous__

Run Time
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">131.77</td>
    <td style="white-space: nowrap; text-align: right">7.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.86%</td>
    <td style="white-space: nowrap; text-align: right">7.28 ms</td>
    <td style="white-space: nowrap; text-align: right">11.76 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">63.21</td>
    <td style="white-space: nowrap; text-align: right">15.82 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.58%</td>
    <td style="white-space: nowrap; text-align: right">15.65 ms</td>
    <td style="white-space: nowrap; text-align: right">20.37 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">51.65</td>
    <td style="white-space: nowrap; text-align: right">19.36 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.78%</td>
    <td style="white-space: nowrap; text-align: right">18.38 ms</td>
    <td style="white-space: nowrap; text-align: right">31.88 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">46.25</td>
    <td style="white-space: nowrap; text-align: right">21.62 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.03%</td>
    <td style="white-space: nowrap; text-align: right">21.00 ms</td>
    <td style="white-space: nowrap; text-align: right">27.41 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">15.02</td>
    <td style="white-space: nowrap; text-align: right">66.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.29%</td>
    <td style="white-space: nowrap; text-align: right">65.85 ms</td>
    <td style="white-space: nowrap; text-align: right">75.59 ms</td>
  </tr>
</table>
Comparison
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap;text-align: right">131.77</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">63.21</td>
    <td style="white-space: nowrap; text-align: right">2.08x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">51.65</td>
    <td style="white-space: nowrap; text-align: right">2.55x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">46.25</td>
    <td style="white-space: nowrap; text-align: right">2.85x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">15.02</td>
    <td style="white-space: nowrap; text-align: right">8.77x</td>
  </tr>
</table>
Memory Usage
<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Memory</th>
      <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">2.76 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">8.82 MB</td>
    <td>3.2x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">8.88 MB</td>
    <td>3.22x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">6.74 MB</td>
    <td>2.44x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">45.14 MB</td>
    <td>16.36x</td>
  </tr>
</table>
<hr/>
