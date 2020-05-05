# Benchmark

This benchmark compares the different `DataStores` available in
`TimeZoneInfo`.

The `TimeZoneInfo` will be tested in three different configurations.
Each version uses a different strategy to keep the data available.
- `time_zone_info_pst` is using
  [`:persistent_term`](https://erlang.org/doc/man/persistent_term.html)
- `time_zone_info_ets` is using `:ets`
  [(Erlang Term Storage)](https://erlang.org/doc/man/ets.html)
- `time_zone_info_map` is using a `GenServer` with a `Map` as state. This
  version isn't an available configuration in `TimeZoneInfo`. The
  `GenServer` version is otherwise only used in the tests.

The inputs for every benchmark run:
- **ok:** 333 `(datetime, time_zone)` arguments that are resulting in a
  `:ok` return value.
- **gap:** 333 `(datetime, time_zone)` arguments that are resulting in a
  `:gap` return tuple.
- **ambiguous:** 333 `(datetime, time_zone)` arguments that are resulting in
  a `:ambiguous` return tuple.
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
    <td style="white-space: nowrap; text-align: right">399.00</td>
    <td style="white-space: nowrap; text-align: right">2.51 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.84%</td>
    <td style="white-space: nowrap; text-align: right">2.44 ms</td>
    <td style="white-space: nowrap; text-align: right">3.22 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">174.66</td>
    <td style="white-space: nowrap; text-align: right">5.73 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.98%</td>
    <td style="white-space: nowrap; text-align: right">5.56 ms</td>
    <td style="white-space: nowrap; text-align: right">8.23 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">125.04</td>
    <td style="white-space: nowrap; text-align: right">8.00 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.02%</td>
    <td style="white-space: nowrap; text-align: right">7.73 ms</td>
    <td style="white-space: nowrap; text-align: right">10.72 ms</td>
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
    <td style="white-space: nowrap;text-align: right">399.00</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">174.66</td>
    <td style="white-space: nowrap; text-align: right">2.28x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">125.04</td>
    <td style="white-space: nowrap; text-align: right">3.19x</td>
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
    <td style="white-space: nowrap">3.78 MB</td>
    <td>4.01x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.84 MB</td>
    <td>4.07x</td>
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
    <td style="white-space: nowrap; text-align: right">1736.58</td>
    <td style="white-space: nowrap; text-align: right">0.58 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.72%</td>
    <td style="white-space: nowrap; text-align: right">0.56 ms</td>
    <td style="white-space: nowrap; text-align: right">0.77 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">333.45</td>
    <td style="white-space: nowrap; text-align: right">3.00 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.83%</td>
    <td style="white-space: nowrap; text-align: right">2.93 ms</td>
    <td style="white-space: nowrap; text-align: right">3.64 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">244.42</td>
    <td style="white-space: nowrap; text-align: right">4.09 ms</td>
    <td style="white-space: nowrap; text-align: right">±5.28%</td>
    <td style="white-space: nowrap; text-align: right">4.03 ms</td>
    <td style="white-space: nowrap; text-align: right">4.76 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1736.58</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">333.45</td>
    <td style="white-space: nowrap; text-align: right">5.21x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">244.42</td>
    <td style="white-space: nowrap; text-align: right">7.1x</td>
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
    <td style="white-space: nowrap">0.31 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">3.09 MB</td>
    <td>9.93x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.12 MB</td>
    <td>10.03x</td>
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
    <td style="white-space: nowrap">time_zone_info_pst</td>
    <td style="white-space: nowrap; text-align: right">486.64</td>
    <td style="white-space: nowrap; text-align: right">2.05 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.54%</td>
    <td style="white-space: nowrap; text-align: right">2.04 ms</td>
    <td style="white-space: nowrap; text-align: right">2.50 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">195.00</td>
    <td style="white-space: nowrap; text-align: right">5.13 ms</td>
    <td style="white-space: nowrap; text-align: right">±12.50%</td>
    <td style="white-space: nowrap; text-align: right">4.98 ms</td>
    <td style="white-space: nowrap; text-align: right">8.13 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">182.22</td>
    <td style="white-space: nowrap; text-align: right">5.49 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.49%</td>
    <td style="white-space: nowrap; text-align: right">5.40 ms</td>
    <td style="white-space: nowrap; text-align: right">6.43 ms</td>
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
    <td style="white-space: nowrap;text-align: right">486.64</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">195.00</td>
    <td style="white-space: nowrap; text-align: right">2.5x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">182.22</td>
    <td style="white-space: nowrap; text-align: right">2.67x</td>
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
    <td style="white-space: nowrap">0.85 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">3.32 MB</td>
    <td>3.91x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">3.35 MB</td>
    <td>3.94x</td>
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
    <td style="white-space: nowrap; text-align: right">205.61</td>
    <td style="white-space: nowrap; text-align: right">4.86 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.37%</td>
    <td style="white-space: nowrap; text-align: right">4.69 ms</td>
    <td style="white-space: nowrap; text-align: right">7.00 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">119.53</td>
    <td style="white-space: nowrap; text-align: right">8.37 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.20%</td>
    <td style="white-space: nowrap; text-align: right">8.23 ms</td>
    <td style="white-space: nowrap; text-align: right">10.24 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">94.75</td>
    <td style="white-space: nowrap; text-align: right">10.55 ms</td>
    <td style="white-space: nowrap; text-align: right">±7.77%</td>
    <td style="white-space: nowrap; text-align: right">10.34 ms</td>
    <td style="white-space: nowrap; text-align: right">12.58 ms</td>
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
    <td style="white-space: nowrap;text-align: right">205.61</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">119.53</td>
    <td style="white-space: nowrap; text-align: right">1.72x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">94.75</td>
    <td style="white-space: nowrap; text-align: right">2.17x</td>
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
    <td style="white-space: nowrap">1.44 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">4.24 MB</td>
    <td>2.95x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">4.32 MB</td>
    <td>3.0x</td>
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
    <td style="white-space: nowrap; text-align: right">2015.93</td>
    <td style="white-space: nowrap; text-align: right">0.50 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.82%</td>
    <td style="white-space: nowrap; text-align: right">0.48 ms</td>
    <td style="white-space: nowrap; text-align: right">0.73 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">487.65</td>
    <td style="white-space: nowrap; text-align: right">2.05 ms</td>
    <td style="white-space: nowrap; text-align: right">±20.64%</td>
    <td style="white-space: nowrap; text-align: right">1.91 ms</td>
    <td style="white-space: nowrap; text-align: right">3.99 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">350.66</td>
    <td style="white-space: nowrap; text-align: right">2.85 ms</td>
    <td style="white-space: nowrap; text-align: right">±16.71%</td>
    <td style="white-space: nowrap; text-align: right">2.69 ms</td>
    <td style="white-space: nowrap; text-align: right">4.55 ms</td>
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
    <td style="white-space: nowrap;text-align: right">2015.93</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">487.65</td>
    <td style="white-space: nowrap; text-align: right">4.13x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">350.66</td>
    <td style="white-space: nowrap; text-align: right">5.75x</td>
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
    <td style="white-space: nowrap">0.25 MB</td>
      <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">1.52 MB</td>
    <td>6.02x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">1.55 MB</td>
    <td>6.14x</td>
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
    <td style="white-space: nowrap; text-align: right">795.97</td>
    <td style="white-space: nowrap; text-align: right">1.26 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.33%</td>
    <td style="white-space: nowrap; text-align: right">1.21 ms</td>
    <td style="white-space: nowrap; text-align: right">1.76 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">309.12</td>
    <td style="white-space: nowrap; text-align: right">3.24 ms</td>
    <td style="white-space: nowrap; text-align: right">±24.53%</td>
    <td style="white-space: nowrap; text-align: right">3.06 ms</td>
    <td style="white-space: nowrap; text-align: right">5.60 ms</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">252.68</td>
    <td style="white-space: nowrap; text-align: right">3.96 ms</td>
    <td style="white-space: nowrap; text-align: right">±14.86%</td>
    <td style="white-space: nowrap; text-align: right">3.75 ms</td>
    <td style="white-space: nowrap; text-align: right">5.99 ms</td>
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
    <td style="white-space: nowrap;text-align: right">795.97</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap; text-align: right">309.12</td>
    <td style="white-space: nowrap; text-align: right">2.58x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap; text-align: right">252.68</td>
    <td style="white-space: nowrap; text-align: right">3.15x</td>
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
    <td style="white-space: nowrap">time_zone_info_ets</td>
    <td style="white-space: nowrap">1.96 MB</td>
    <td>3.53x</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">time_zone_info_map</td>
    <td style="white-space: nowrap">1.93 MB</td>
    <td>3.48x</td>
  </tr>
</table>
<hr/>
