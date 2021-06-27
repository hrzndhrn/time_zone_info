
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
    <td style="white-space: nowrap">Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz</td>
  </tr><tr>
    <th style="white-space: nowrap">Number of Available Cores</th>
    <td style="white-space: nowrap">8</td>
  </tr><tr>
    <th style="white-space: nowrap">Available Memory</th>
    <td style="white-space: nowrap">16 GB</td>
  </tr><tr>
    <th style="white-space: nowrap">Elixir Version</th>
    <td style="white-space: nowrap">1.11.3</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">23.2</td>
  </tr>
</table>

## Configuration

Benchmark suite executing with the following configuration:

<table style="width: 1%">
  <tr>
    <th style="width: 1%">:time</th>
    <td style="white-space: nowrap">30 s</td>
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
    <td style="white-space: nowrap; text-align: right">390.88 K</td>
    <td style="white-space: nowrap; text-align: right">2.56 μs</td>
    <td style="white-space: nowrap; text-align: right">±1631.94%</td>
    <td style="white-space: nowrap; text-align: right">1.97 μs</td>
    <td style="white-space: nowrap; text-align: right">3.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">178.43 K</td>
    <td style="white-space: nowrap; text-align: right">5.60 μs</td>
    <td style="white-space: nowrap; text-align: right">±659.79%</td>
    <td style="white-space: nowrap; text-align: right">4.97 μs</td>
    <td style="white-space: nowrap; text-align: right">7.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">4.91 K</td>
    <td style="white-space: nowrap; text-align: right">203.69 μs</td>
    <td style="white-space: nowrap; text-align: right">±19.38%</td>
    <td style="white-space: nowrap; text-align: right">189.97 μs</td>
    <td style="white-space: nowrap; text-align: right">347.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.78 K</td>
    <td style="white-space: nowrap; text-align: right">264.87 μs</td>
    <td style="white-space: nowrap; text-align: right">±8.22%</td>
    <td style="white-space: nowrap; text-align: right">259.97 μs</td>
    <td style="white-space: nowrap; text-align: right">362.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">390.88 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">178.43 K</td>
    <td style="white-space: nowrap; text-align: right">2.19x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">4.91 K</td>
    <td style="white-space: nowrap; text-align: right">79.62x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.78 K</td>
    <td style="white-space: nowrap; text-align: right">103.53x</td>
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
    <td style="white-space: nowrap">1.84 KB</td>
    <td>2.7x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">23.81 KB</td>
    <td>35.03x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">117.18 KB</td>
    <td>172.4x</td>
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
    <td style="white-space: nowrap; text-align: right">467.62 K</td>
    <td style="white-space: nowrap; text-align: right">2.14 μs</td>
    <td style="white-space: nowrap; text-align: right">±2647.34%</td>
    <td style="white-space: nowrap; text-align: right">1.97 μs</td>
    <td style="white-space: nowrap; text-align: right">2.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">407.53 K</td>
    <td style="white-space: nowrap; text-align: right">2.45 μs</td>
    <td style="white-space: nowrap; text-align: right">±1507.80%</td>
    <td style="white-space: nowrap; text-align: right">1.97 μs</td>
    <td style="white-space: nowrap; text-align: right">3.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">31.36 K</td>
    <td style="white-space: nowrap; text-align: right">31.89 μs</td>
    <td style="white-space: nowrap; text-align: right">±66.13%</td>
    <td style="white-space: nowrap; text-align: right">30.97 μs</td>
    <td style="white-space: nowrap; text-align: right">46.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">5.21 K</td>
    <td style="white-space: nowrap; text-align: right">192.04 μs</td>
    <td style="white-space: nowrap; text-align: right">±17.28%</td>
    <td style="white-space: nowrap; text-align: right">180.97 μs</td>
    <td style="white-space: nowrap; text-align: right">313.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">467.62 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">407.53 K</td>
    <td style="white-space: nowrap; text-align: right">1.15x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">31.36 K</td>
    <td style="white-space: nowrap; text-align: right">14.91x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">5.21 K</td>
    <td style="white-space: nowrap; text-align: right">89.8x</td>
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
    <td style="white-space: nowrap">2.72 KB</td>
    <td>6.96x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">22.34 KB</td>
    <td>57.2x</td>
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
    <td style="white-space: nowrap; text-align: right">474.20 K</td>
    <td style="white-space: nowrap; text-align: right">2.11 μs</td>
    <td style="white-space: nowrap; text-align: right">±2478.14%</td>
    <td style="white-space: nowrap; text-align: right">1.97 μs</td>
    <td style="white-space: nowrap; text-align: right">3.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">406.96 K</td>
    <td style="white-space: nowrap; text-align: right">2.46 μs</td>
    <td style="white-space: nowrap; text-align: right">±1713.59%</td>
    <td style="white-space: nowrap; text-align: right">1.97 μs</td>
    <td style="white-space: nowrap; text-align: right">3.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">26.14 K</td>
    <td style="white-space: nowrap; text-align: right">38.25 μs</td>
    <td style="white-space: nowrap; text-align: right">±43.39%</td>
    <td style="white-space: nowrap; text-align: right">36.97 μs</td>
    <td style="white-space: nowrap; text-align: right">58.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">5.07 K</td>
    <td style="white-space: nowrap; text-align: right">197.14 μs</td>
    <td style="white-space: nowrap; text-align: right">±20.49%</td>
    <td style="white-space: nowrap; text-align: right">182.97 μs</td>
    <td style="white-space: nowrap; text-align: right">350.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">474.20 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">406.96 K</td>
    <td style="white-space: nowrap; text-align: right">1.17x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">26.14 K</td>
    <td style="white-space: nowrap; text-align: right">18.14x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">5.07 K</td>
    <td style="white-space: nowrap; text-align: right">93.48x</td>
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
    <td style="white-space: nowrap">4.94 KB</td>
    <td>11.09x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">22.42 KB</td>
    <td>50.35x</td>
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
    <td style="white-space: nowrap; text-align: right">13.03 K</td>
    <td style="white-space: nowrap; text-align: right">76.74 μs</td>
    <td style="white-space: nowrap; text-align: right">±19.95%</td>
    <td style="white-space: nowrap; text-align: right">74.97 μs</td>
    <td style="white-space: nowrap; text-align: right">108.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">12.03 K</td>
    <td style="white-space: nowrap; text-align: right">83.11 μs</td>
    <td style="white-space: nowrap; text-align: right">±18.83%</td>
    <td style="white-space: nowrap; text-align: right">80.97 μs</td>
    <td style="white-space: nowrap; text-align: right">123.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">5.21 K</td>
    <td style="white-space: nowrap; text-align: right">192.08 μs</td>
    <td style="white-space: nowrap; text-align: right">±25.15%</td>
    <td style="white-space: nowrap; text-align: right">178.97 μs</td>
    <td style="white-space: nowrap; text-align: right">329.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">1.48 K</td>
    <td style="white-space: nowrap; text-align: right">676.08 μs</td>
    <td style="white-space: nowrap; text-align: right">±28.41%</td>
    <td style="white-space: nowrap; text-align: right">787.97 μs</td>
    <td style="white-space: nowrap; text-align: right">909.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">13.03 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">12.03 K</td>
    <td style="white-space: nowrap; text-align: right">1.08x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">5.21 K</td>
    <td style="white-space: nowrap; text-align: right">2.5x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">1.48 K</td>
    <td style="white-space: nowrap; text-align: right">8.81x</td>
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
    <td style="white-space: nowrap">16.12 KB</td>
<td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">19.43 KB</td>
    <td>1.21x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">22.34 KB</td>
    <td>1.39x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">12.98 KB</td>
    <td>0.81x</td>
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
    <td style="white-space: nowrap; text-align: right">229.14 K</td>
    <td style="white-space: nowrap; text-align: right">4.36 μs</td>
    <td style="white-space: nowrap; text-align: right">±741.65%</td>
    <td style="white-space: nowrap; text-align: right">3.97 μs</td>
    <td style="white-space: nowrap; text-align: right">6.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">125.69 K</td>
    <td style="white-space: nowrap; text-align: right">7.96 μs</td>
    <td style="white-space: nowrap; text-align: right">±430.44%</td>
    <td style="white-space: nowrap; text-align: right">7.97 μs</td>
    <td style="white-space: nowrap; text-align: right">11.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">36.05 K</td>
    <td style="white-space: nowrap; text-align: right">27.74 μs</td>
    <td style="white-space: nowrap; text-align: right">±70.63%</td>
    <td style="white-space: nowrap; text-align: right">26.97 μs</td>
    <td style="white-space: nowrap; text-align: right">40.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">4.29 K</td>
    <td style="white-space: nowrap; text-align: right">233.18 μs</td>
    <td style="white-space: nowrap; text-align: right">±13.43%</td>
    <td style="white-space: nowrap; text-align: right">221.97 μs</td>
    <td style="white-space: nowrap; text-align: right">349.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">229.14 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">125.69 K</td>
    <td style="white-space: nowrap; text-align: right">1.82x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">36.05 K</td>
    <td style="white-space: nowrap; text-align: right">6.36x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap; text-align: right">4.29 K</td>
    <td style="white-space: nowrap; text-align: right">53.43x</td>
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
    <td style="white-space: nowrap">2.72 KB</td>
    <td>4.77x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoneinfo</td>
    <td style="white-space: nowrap">30.26 KB</td>
    <td>53.05x</td>
  </tr>

</table>


<hr/>

