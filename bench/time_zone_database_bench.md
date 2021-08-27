
# Benchmark

This benchmark compares `TimeZoneInfo` with
- [`Tzdata`](https://github.com/lau/tzdata),
- [`Tz`](https://github.com/mathieuprog/tz),
- [`zoneinfo`](https://github.com/smartrent/zoneinfo)

`TimeZoneInfo` is using `DataStore.PersistentTerm` in this benchmark.

For the benchmark, each of them calls the function
`TimeZoneDatabase.time_zone_periods_from_wall_datetime/2`.

It is relatively hard to compare these libs because the performance depends on
the configurations of each lib. Therefore, the values here are a rough guide.


## System

Benchmark suite executing on the following system:

<table style="width: 1%">
  <tr>
    <th style="width: 1%; white-space: nowrap">Operating System</th>
    <td>macOS</td>
  </tr><tr>
    <th style="white-space: nowrap">CPU Information</th>
    <td style="white-space: nowrap">Apple M1</td>
  </tr><tr>
    <th style="white-space: nowrap">Number of Available Cores</th>
    <td style="white-space: nowrap">8</td>
  </tr><tr>
    <th style="white-space: nowrap">Available Memory</th>
    <td style="white-space: nowrap">16 GB</td>
  </tr><tr>
    <th style="white-space: nowrap">Elixir Version</th>
    <td style="white-space: nowrap">1.12.2</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">24.0.5</td>
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




__Input: Europe/Berlin 2020-03-29 02:00:01 (gap)__

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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1245.45 K</td>
    <td style="white-space: nowrap; text-align: right">0.80 μs</td>
    <td style="white-space: nowrap; text-align: right">±3659.97%</td>
    <td style="white-space: nowrap; text-align: right">0.99 μs</td>
    <td style="white-space: nowrap; text-align: right">0.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">559.04 K</td>
    <td style="white-space: nowrap; text-align: right">1.79 μs</td>
    <td style="white-space: nowrap; text-align: right">±694.68%</td>
    <td style="white-space: nowrap; text-align: right">1.99 μs</td>
    <td style="white-space: nowrap; text-align: right">1.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">10.49 K</td>
    <td style="white-space: nowrap; text-align: right">95.31 μs</td>
    <td style="white-space: nowrap; text-align: right">±5.01%</td>
    <td style="white-space: nowrap; text-align: right">92.99 μs</td>
    <td style="white-space: nowrap; text-align: right">106.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">4.13 K</td>
    <td style="white-space: nowrap; text-align: right">242.22 μs</td>
    <td style="white-space: nowrap; text-align: right">±22.43%</td>
    <td style="white-space: nowrap; text-align: right">236.99 μs</td>
    <td style="white-space: nowrap; text-align: right">409.99 μs</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap;text-align: right">1245.45 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">559.04 K</td>
    <td style="white-space: nowrap; text-align: right">2.23x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">10.49 K</td>
    <td style="white-space: nowrap; text-align: right">118.71x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">4.13 K</td>
    <td style="white-space: nowrap; text-align: right">301.67x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.68 KB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">1.87 KB</td>
    <td>2.75x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">117.71 KB</td>
    <td>173.18x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">24.07 KB</td>
    <td>35.41x</td>
  </tr>

</table>


<hr/>


__Input: Europe/Berlin 2020-06-01 00:00:00__

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
    <td style="white-space: nowrap; text-align: right">1.62 M</td>
    <td style="white-space: nowrap; text-align: right">0.62 μs</td>
    <td style="white-space: nowrap; text-align: right">±2705.52%</td>
    <td style="white-space: nowrap; text-align: right">0.99 μs</td>
    <td style="white-space: nowrap; text-align: right">0.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.34 M</td>
    <td style="white-space: nowrap; text-align: right">0.74 μs</td>
    <td style="white-space: nowrap; text-align: right">±3238.22%</td>
    <td style="white-space: nowrap; text-align: right">0.99 μs</td>
    <td style="white-space: nowrap; text-align: right">0.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0568 M</td>
    <td style="white-space: nowrap; text-align: right">17.59 μs</td>
    <td style="white-space: nowrap; text-align: right">±25.64%</td>
    <td style="white-space: nowrap; text-align: right">16.99 μs</td>
    <td style="white-space: nowrap; text-align: right">19.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00426 M</td>
    <td style="white-space: nowrap; text-align: right">234.86 μs</td>
    <td style="white-space: nowrap; text-align: right">±22.50%</td>
    <td style="white-space: nowrap; text-align: right">228.99 μs</td>
    <td style="white-space: nowrap; text-align: right">395.67 μs</td>
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
    <td style="white-space: nowrap;text-align: right">1.62 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.34 M</td>
    <td style="white-space: nowrap; text-align: right">1.2x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0568 M</td>
    <td style="white-space: nowrap; text-align: right">28.44x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00426 M</td>
    <td style="white-space: nowrap; text-align: right">379.73x</td>
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
    <td style="white-space: nowrap">0.39 KB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.57 KB</td>
    <td>1.46x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.89 KB</td>
    <td>7.4x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.57 KB</td>
    <td>57.78x</td>
  </tr>

</table>


<hr/>


__Input: Europe/Berlin 2020-10-25 02:00:01 (ambiguous)__

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
    <td style="white-space: nowrap; text-align: right">1.54 M</td>
    <td style="white-space: nowrap; text-align: right">0.65 μs</td>
    <td style="white-space: nowrap; text-align: right">±3632.14%</td>
    <td style="white-space: nowrap; text-align: right">0.99 μs</td>
    <td style="white-space: nowrap; text-align: right">0.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.33 M</td>
    <td style="white-space: nowrap; text-align: right">0.75 μs</td>
    <td style="white-space: nowrap; text-align: right">±3451.61%</td>
    <td style="white-space: nowrap; text-align: right">0.99 μs</td>
    <td style="white-space: nowrap; text-align: right">0.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0513 M</td>
    <td style="white-space: nowrap; text-align: right">19.48 μs</td>
    <td style="white-space: nowrap; text-align: right">±27.53%</td>
    <td style="white-space: nowrap; text-align: right">18.99 μs</td>
    <td style="white-space: nowrap; text-align: right">23.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00423 M</td>
    <td style="white-space: nowrap; text-align: right">236.44 μs</td>
    <td style="white-space: nowrap; text-align: right">±21.76%</td>
    <td style="white-space: nowrap; text-align: right">230.99 μs</td>
    <td style="white-space: nowrap; text-align: right">395.99 μs</td>
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
    <td style="white-space: nowrap;text-align: right">1.54 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.33 M</td>
    <td style="white-space: nowrap; text-align: right">1.16x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0513 M</td>
    <td style="white-space: nowrap; text-align: right">30.07x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00423 M</td>
    <td style="white-space: nowrap; text-align: right">364.89x</td>
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
    <td style="white-space: nowrap">0.45 KB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.63 KB</td>
    <td>1.42x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">5.28 KB</td>
    <td>11.86x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.65 KB</td>
    <td>50.86x</td>
  </tr>

</table>


<hr/>


__Input: Europe/Berlin 2099-06-01 00:00:00__

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
    <td style="white-space: nowrap; text-align: right">44.83 K</td>
    <td style="white-space: nowrap; text-align: right">22.31 μs</td>
    <td style="white-space: nowrap; text-align: right">±92.55%</td>
    <td style="white-space: nowrap; text-align: right">19.99 μs</td>
    <td style="white-space: nowrap; text-align: right">85.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">40.01 K</td>
    <td style="white-space: nowrap; text-align: right">25.00 μs</td>
    <td style="white-space: nowrap; text-align: right">±60.67%</td>
    <td style="white-space: nowrap; text-align: right">21.99 μs</td>
    <td style="white-space: nowrap; text-align: right">98.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">4.26 K</td>
    <td style="white-space: nowrap; text-align: right">234.77 μs</td>
    <td style="white-space: nowrap; text-align: right">±22.19%</td>
    <td style="white-space: nowrap; text-align: right">227.99 μs</td>
    <td style="white-space: nowrap; text-align: right">398.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.27 K</td>
    <td style="white-space: nowrap; text-align: right">306.18 μs</td>
    <td style="white-space: nowrap; text-align: right">±33.53%</td>
    <td style="white-space: nowrap; text-align: right">341.99 μs</td>
    <td style="white-space: nowrap; text-align: right">634.93 μs</td>
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
    <td style="white-space: nowrap;text-align: right">44.83 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">40.01 K</td>
    <td style="white-space: nowrap; text-align: right">1.12x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">4.26 K</td>
    <td style="white-space: nowrap; text-align: right">10.52x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.27 K</td>
    <td style="white-space: nowrap; text-align: right">13.73x</td>
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
    <td style="white-space: nowrap">16.77 KB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">19.91 KB</td>
    <td>1.19x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.57 KB</td>
    <td>1.35x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">13.76 KB</td>
    <td>0.82x</td>
  </tr>

</table>


<hr/>


__Input: Europe/Paris 1950-06-27 22:34:00__

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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">854.38 K</td>
    <td style="white-space: nowrap; text-align: right">1.17 μs</td>
    <td style="white-space: nowrap; text-align: right">±1763.65%</td>
    <td style="white-space: nowrap; text-align: right">0.99 μs</td>
    <td style="white-space: nowrap; text-align: right">1.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">460.51 K</td>
    <td style="white-space: nowrap; text-align: right">2.17 μs</td>
    <td style="white-space: nowrap; text-align: right">±625.14%</td>
    <td style="white-space: nowrap; text-align: right">1.99 μs</td>
    <td style="white-space: nowrap; text-align: right">2.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">65.08 K</td>
    <td style="white-space: nowrap; text-align: right">15.37 μs</td>
    <td style="white-space: nowrap; text-align: right">±38.59%</td>
    <td style="white-space: nowrap; text-align: right">14.99 μs</td>
    <td style="white-space: nowrap; text-align: right">18.99 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">3.91 K</td>
    <td style="white-space: nowrap; text-align: right">255.95 μs</td>
    <td style="white-space: nowrap; text-align: right">±21.89%</td>
    <td style="white-space: nowrap; text-align: right">250.99 μs</td>
    <td style="white-space: nowrap; text-align: right">418.99 μs</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap;text-align: right">854.38 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">460.51 K</td>
    <td style="white-space: nowrap; text-align: right">1.86x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">65.08 K</td>
    <td style="white-space: nowrap; text-align: right">13.13x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">3.91 K</td>
    <td style="white-space: nowrap; text-align: right">218.67x</td>
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
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">0.57 KB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap">0.39 KB</td>
    <td>0.68x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">2.89 KB</td>
    <td>5.07x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">30.50 KB</td>
    <td>53.48x</td>
  </tr>

</table>


<hr/>

