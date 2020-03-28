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
- **last_year:** 1000 `(datetime, time_zone)` arguments with random time zone
  and a date time from now to one year in the past. The data is calculated
  once for all test candidates.
- **berlin_gap_2020**: Gaps in the time zone `Europe/Berlin` in 2020.
- **berlin_ambiguous_2020**: Ambiguous date time in the time zone
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
    <td style="white-space: nowrap; text-align: right">190.33</td>
    <td style="white-space: nowrap; text-align: right">5.25 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.05%</td>
    <td style="white-space: nowrap; text-align: right">5.14 ms</td>
    <td style="white-space: nowrap; text-align: right">6.39 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">118.35</td>
    <td style="white-space: nowrap; text-align: right">8.45 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.71%</td>
    <td style="white-space: nowrap; text-align: right">8.36 ms</td>
    <td style="white-space: nowrap; text-align: right">10.28 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">103.82</td>
    <td style="white-space: nowrap; text-align: right">9.63 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.59%</td>
    <td style="white-space: nowrap; text-align: right">9.52 ms</td>
    <td style="white-space: nowrap; text-align: right">11.66 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">90.26</td>
    <td style="white-space: nowrap; text-align: right">11.08 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.63%</td>
    <td style="white-space: nowrap; text-align: right">10.98 ms</td>
    <td style="white-space: nowrap; text-align: right">13.58 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">46.78</td>
    <td style="white-space: nowrap; text-align: right">21.37 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.48%</td>
    <td style="white-space: nowrap; text-align: right">21.23 ms</td>
    <td style="white-space: nowrap; text-align: right">23.99 ms</td>
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
    <td style="white-space: nowrap;text-align: right">190.33</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">118.35</td>
    <td style="white-space: nowrap; text-align: right">1.61x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">103.82</td>
    <td style="white-space: nowrap; text-align: right">1.83x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">90.26</td>
    <td style="white-space: nowrap; text-align: right">2.11x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">46.78</td>
    <td style="white-space: nowrap; text-align: right">4.07x</td>
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
    <td style="white-space: nowrap">1.68 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">4.18 MB</td>
    <td>2.48x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.73 MB</td>
    <td>1.03x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">4.13 MB</td>
    <td>2.45x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">6.22 MB</td>
    <td>3.7x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">622.72</td>
    <td style="white-space: nowrap; text-align: right">1.61 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.86%</td>
    <td style="white-space: nowrap; text-align: right">1.55 ms</td>
    <td style="white-space: nowrap; text-align: right">2.27 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">615.76</td>
    <td style="white-space: nowrap; text-align: right">1.62 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.22%</td>
    <td style="white-space: nowrap; text-align: right">1.56 ms</td>
    <td style="white-space: nowrap; text-align: right">2.26 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">118.83</td>
    <td style="white-space: nowrap; text-align: right">8.42 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.94%</td>
    <td style="white-space: nowrap; text-align: right">8.35 ms</td>
    <td style="white-space: nowrap; text-align: right">9.76 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">88.70</td>
    <td style="white-space: nowrap; text-align: right">11.27 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.36%</td>
    <td style="white-space: nowrap; text-align: right">11.21 ms</td>
    <td style="white-space: nowrap; text-align: right">12.86 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">28.58</td>
    <td style="white-space: nowrap; text-align: right">34.99 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.46%</td>
    <td style="white-space: nowrap; text-align: right">34.81 ms</td>
    <td style="white-space: nowrap; text-align: right">38.34 ms</td>
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
    <td style="white-space: nowrap;text-align: right">622.72</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">615.76</td>
    <td style="white-space: nowrap; text-align: right">1.01x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">118.83</td>
    <td style="white-space: nowrap; text-align: right">5.24x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">88.70</td>
    <td style="white-space: nowrap; text-align: right">7.02x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">28.58</td>
    <td style="white-space: nowrap; text-align: right">21.79x</td>
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
    <td style="white-space: nowrap">0.93 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.31 MB</td>
    <td>0.33x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">10.23 MB</td>
    <td>10.99x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">10.33 MB</td>
    <td>11.1x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">3.97 MB</td>
    <td>4.26x</td>
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
    <td style="white-space: nowrap; text-align: right">572.39</td>
    <td style="white-space: nowrap; text-align: right">1.75 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.38%</td>
    <td style="white-space: nowrap; text-align: right">1.69 ms</td>
    <td style="white-space: nowrap; text-align: right">2.38 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">265.76</td>
    <td style="white-space: nowrap; text-align: right">3.76 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.04%</td>
    <td style="white-space: nowrap; text-align: right">3.67 ms</td>
    <td style="white-space: nowrap; text-align: right">4.69 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">92.55</td>
    <td style="white-space: nowrap; text-align: right">10.81 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.52%</td>
    <td style="white-space: nowrap; text-align: right">10.77 ms</td>
    <td style="white-space: nowrap; text-align: right">12.52 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">71.60</td>
    <td style="white-space: nowrap; text-align: right">13.97 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.64%</td>
    <td style="white-space: nowrap; text-align: right">13.81 ms</td>
    <td style="white-space: nowrap; text-align: right">16.74 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">5.72</td>
    <td style="white-space: nowrap; text-align: right">174.94 ms</td>
    <td style="white-space: nowrap; text-align: right">±1.82%</td>
    <td style="white-space: nowrap; text-align: right">174.14 ms</td>
    <td style="white-space: nowrap; text-align: right">188.34 ms</td>
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
    <td style="white-space: nowrap;text-align: right">572.39</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">265.76</td>
    <td style="white-space: nowrap; text-align: right">2.15x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">92.55</td>
    <td style="white-space: nowrap; text-align: right">6.18x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">71.60</td>
    <td style="white-space: nowrap; text-align: right">7.99x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">5.72</td>
    <td style="white-space: nowrap; text-align: right">100.13x</td>
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
    <td style="white-space: nowrap">0.29 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap">1.94 MB</td>
    <td>6.71x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">11.51 MB</td>
    <td>39.71x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">11.62 MB</td>
    <td>40.07x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">135.87 MB</td>
    <td>468.67x</td>
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
    <td style="white-space: nowrap; text-align: right">124.74</td>
    <td style="white-space: nowrap; text-align: right">8.02 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.07%</td>
    <td style="white-space: nowrap; text-align: right">7.94 ms</td>
    <td style="white-space: nowrap; text-align: right">9.30 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">88.74</td>
    <td style="white-space: nowrap; text-align: right">11.27 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.33%</td>
    <td style="white-space: nowrap; text-align: right">11.20 ms</td>
    <td style="white-space: nowrap; text-align: right">13.15 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">69.19</td>
    <td style="white-space: nowrap; text-align: right">14.45 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.25%</td>
    <td style="white-space: nowrap; text-align: right">14.36 ms</td>
    <td style="white-space: nowrap; text-align: right">17.31 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">34.63</td>
    <td style="white-space: nowrap; text-align: right">28.88 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.08%</td>
    <td style="white-space: nowrap; text-align: right">28.71 ms</td>
    <td style="white-space: nowrap; text-align: right">31.89 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">17.71</td>
    <td style="white-space: nowrap; text-align: right">56.48 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.31%</td>
    <td style="white-space: nowrap; text-align: right">56.35 ms</td>
    <td style="white-space: nowrap; text-align: right">60.66 ms</td>
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
    <td style="white-space: nowrap;text-align: right">124.74</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">88.74</td>
    <td style="white-space: nowrap; text-align: right">1.41x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">69.19</td>
    <td style="white-space: nowrap; text-align: right">1.8x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">34.63</td>
    <td style="white-space: nowrap; text-align: right">3.6x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">17.71</td>
    <td style="white-space: nowrap; text-align: right">7.04x</td>
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
    <td style="white-space: nowrap">2.38 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">4.54 MB</td>
    <td>1.91x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">4.64 MB</td>
    <td>1.95x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">8.34 MB</td>
    <td>3.51x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">41.31 MB</td>
    <td>17.38x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">685.09</td>
    <td style="white-space: nowrap; text-align: right">1.46 ms</td>
    <td style="white-space: nowrap; text-align: right">±11.25%</td>
    <td style="white-space: nowrap; text-align: right">1.40 ms</td>
    <td style="white-space: nowrap; text-align: right">2.18 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">605.12</td>
    <td style="white-space: nowrap; text-align: right">1.65 ms</td>
    <td style="white-space: nowrap; text-align: right">±13.45%</td>
    <td style="white-space: nowrap; text-align: right">1.58 ms</td>
    <td style="white-space: nowrap; text-align: right">2.59 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">173.92</td>
    <td style="white-space: nowrap; text-align: right">5.75 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.04%</td>
    <td style="white-space: nowrap; text-align: right">5.63 ms</td>
    <td style="white-space: nowrap; text-align: right">7.27 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">111.14</td>
    <td style="white-space: nowrap; text-align: right">9.00 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.93%</td>
    <td style="white-space: nowrap; text-align: right">8.88 ms</td>
    <td style="white-space: nowrap; text-align: right">11.96 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">66.80</td>
    <td style="white-space: nowrap; text-align: right">14.97 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.00%</td>
    <td style="white-space: nowrap; text-align: right">14.92 ms</td>
    <td style="white-space: nowrap; text-align: right">16.90 ms</td>
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
    <td style="white-space: nowrap;text-align: right">685.09</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">605.12</td>
    <td style="white-space: nowrap; text-align: right">1.13x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">173.92</td>
    <td style="white-space: nowrap; text-align: right">3.94x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">111.14</td>
    <td style="white-space: nowrap; text-align: right">6.16x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">66.80</td>
    <td style="white-space: nowrap; text-align: right">10.26x</td>
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
    <td style="white-space: nowrap">0.77 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.30 MB</td>
    <td>0.39x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">5.10 MB</td>
    <td>6.66x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">5.20 MB</td>
    <td>6.78x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">4.63 MB</td>
    <td>6.04x</td>
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
    <td style="white-space: nowrap; text-align: right">549.22</td>
    <td style="white-space: nowrap; text-align: right">1.82 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.72%</td>
    <td style="white-space: nowrap; text-align: right">1.76 ms</td>
    <td style="white-space: nowrap; text-align: right">2.55 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">288.13</td>
    <td style="white-space: nowrap; text-align: right">3.47 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.08%</td>
    <td style="white-space: nowrap; text-align: right">3.38 ms</td>
    <td style="white-space: nowrap; text-align: right">4.58 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">213.54</td>
    <td style="white-space: nowrap; text-align: right">4.68 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.36%</td>
    <td style="white-space: nowrap; text-align: right">4.55 ms</td>
    <td style="white-space: nowrap; text-align: right">6.48 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">200.15</td>
    <td style="white-space: nowrap; text-align: right">5.00 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.10%</td>
    <td style="white-space: nowrap; text-align: right">4.89 ms</td>
    <td style="white-space: nowrap; text-align: right">6.36 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">189.02</td>
    <td style="white-space: nowrap; text-align: right">5.29 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.78%</td>
    <td style="white-space: nowrap; text-align: right">5.20 ms</td>
    <td style="white-space: nowrap; text-align: right">6.60 ms</td>
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
    <td style="white-space: nowrap;text-align: right">549.22</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">288.13</td>
    <td style="white-space: nowrap; text-align: right">1.91x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">213.54</td>
    <td style="white-space: nowrap; text-align: right">2.57x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">200.15</td>
    <td style="white-space: nowrap; text-align: right">2.74x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">189.02</td>
    <td style="white-space: nowrap; text-align: right">2.91x</td>
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
    <td style="white-space: nowrap">0.72 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">1.92 MB</td>
    <td>2.66x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">1.92 MB</td>
    <td>2.67x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">1.29 MB</td>
    <td>1.79x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">1.46 MB</td>
    <td>2.03x</td>
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
    <td style="white-space: nowrap; text-align: right">65.65</td>
    <td style="white-space: nowrap; text-align: right">15.23 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.94%</td>
    <td style="white-space: nowrap; text-align: right">15.10 ms</td>
    <td style="white-space: nowrap; text-align: right">17.48 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">43.68</td>
    <td style="white-space: nowrap; text-align: right">22.90 ms</td>
    <td style="white-space: nowrap; text-align: right">±3.91%</td>
    <td style="white-space: nowrap; text-align: right">22.76 ms</td>
    <td style="white-space: nowrap; text-align: right">26.05 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">32.88</td>
    <td style="white-space: nowrap; text-align: right">30.41 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.84%</td>
    <td style="white-space: nowrap; text-align: right">30.23 ms</td>
    <td style="white-space: nowrap; text-align: right">36.77 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">17.94</td>
    <td style="white-space: nowrap; text-align: right">55.75 ms</td>
    <td style="white-space: nowrap; text-align: right">±2.88%</td>
    <td style="white-space: nowrap; text-align: right">55.43 ms</td>
    <td style="white-space: nowrap; text-align: right">62.55 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">14.13</td>
    <td style="white-space: nowrap; text-align: right">70.79 ms</td>
    <td style="white-space: nowrap; text-align: right">±4.24%</td>
    <td style="white-space: nowrap; text-align: right">69.91 ms</td>
    <td style="white-space: nowrap; text-align: right">86.27 ms</td>
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
    <td style="white-space: nowrap;text-align: right">65.65</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">43.68</td>
    <td style="white-space: nowrap; text-align: right">1.5x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">32.88</td>
    <td style="white-space: nowrap; text-align: right">2.0x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">17.94</td>
    <td style="white-space: nowrap; text-align: right">3.66x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">14.13</td>
    <td style="white-space: nowrap; text-align: right">4.65x</td>
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
    <td style="white-space: nowrap">4.78 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">10.62 MB</td>
    <td>2.22x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">10.72 MB</td>
    <td>2.24x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">16.03 MB</td>
    <td>3.35x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">44.74 MB</td>
    <td>9.36x</td>
  </tr>
</table>
<hr/>
