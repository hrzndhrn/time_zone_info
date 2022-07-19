
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
    <td style="white-space: nowrap">1.13.4</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">24.3</td>
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
    <td style="white-space: nowrap; text-align: right">1309.65 K</td>
    <td style="white-space: nowrap; text-align: right">0.76 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;214.71%</td>
    <td style="white-space: nowrap; text-align: right">0.70 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">543.24 K</td>
    <td style="white-space: nowrap; text-align: right">1.84 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1028.18%</td>
    <td style="white-space: nowrap; text-align: right">2 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">2 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">11.01 K</td>
    <td style="white-space: nowrap; text-align: right">90.83 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;5.35%</td>
    <td style="white-space: nowrap; text-align: right">91 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">103 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">5.00 K</td>
    <td style="white-space: nowrap; text-align: right">199.96 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;18.39%</td>
    <td style="white-space: nowrap; text-align: right">198 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">287 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">1309.65 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">543.24 K</td>
    <td style="white-space: nowrap; text-align: right">2.41x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">11.01 K</td>
    <td style="white-space: nowrap; text-align: right">118.96x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">5.00 K</td>
    <td style="white-space: nowrap; text-align: right">261.88x</td>
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
    <td style="white-space: nowrap">117.59 KB</td>
    <td>173.0x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">23.89 KB</td>
    <td>35.15x</td>
  </tr>
</table>



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
    <td style="white-space: nowrap; text-align: right">1.64 M</td>
    <td style="white-space: nowrap; text-align: right">0.61 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;13.15%</td>
    <td style="white-space: nowrap; text-align: right">0.61 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.77 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.27 M</td>
    <td style="white-space: nowrap; text-align: right">0.79 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4329.70%</td>
    <td style="white-space: nowrap; text-align: right">1 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0576 M</td>
    <td style="white-space: nowrap; text-align: right">17.37 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;26.89%</td>
    <td style="white-space: nowrap; text-align: right">17 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">19 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00504 M</td>
    <td style="white-space: nowrap; text-align: right">198.52 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;18.61%</td>
    <td style="white-space: nowrap; text-align: right">195 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">288 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">1.64 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.27 M</td>
    <td style="white-space: nowrap; text-align: right">1.29x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0576 M</td>
    <td style="white-space: nowrap; text-align: right">28.41x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00504 M</td>
    <td style="white-space: nowrap; text-align: right">324.74x</td>
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
    <td style="white-space: nowrap">22.39 KB</td>
    <td>57.32x</td>
  </tr>
</table>



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
    <td style="white-space: nowrap; text-align: right">1.66 M</td>
    <td style="white-space: nowrap; text-align: right">0.60 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;5.71%</td>
    <td style="white-space: nowrap; text-align: right">0.60 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.71 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.38 M</td>
    <td style="white-space: nowrap; text-align: right">0.73 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;9.73%</td>
    <td style="white-space: nowrap; text-align: right">0.72 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.90 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0521 M</td>
    <td style="white-space: nowrap; text-align: right">19.20 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;24.80%</td>
    <td style="white-space: nowrap; text-align: right">19 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">23 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00497 M</td>
    <td style="white-space: nowrap; text-align: right">201.02 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;63.12%</td>
    <td style="white-space: nowrap; text-align: right">196 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">292 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">1.66 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">1.38 M</td>
    <td style="white-space: nowrap; text-align: right">1.21x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0521 M</td>
    <td style="white-space: nowrap; text-align: right">31.92x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00497 M</td>
    <td style="white-space: nowrap; text-align: right">334.24x</td>
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
    <td style="white-space: nowrap">22.47 KB</td>
    <td>50.46x</td>
  </tr>
</table>



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
    <td style="white-space: nowrap; text-align: right">50.01 K</td>
    <td style="white-space: nowrap; text-align: right">20.00 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;25.24%</td>
    <td style="white-space: nowrap; text-align: right">20 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">25 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">46.08 K</td>
    <td style="white-space: nowrap; text-align: right">21.70 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;9.51%</td>
    <td style="white-space: nowrap; text-align: right">22 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">24 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">5.04 K</td>
    <td style="white-space: nowrap; text-align: right">198.54 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;18.90%</td>
    <td style="white-space: nowrap; text-align: right">195 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">289 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.45 K</td>
    <td style="white-space: nowrap; text-align: right">290.27 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;24.88%</td>
    <td style="white-space: nowrap; text-align: right">332 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">354 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">50.01 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">46.08 K</td>
    <td style="white-space: nowrap; text-align: right">1.09x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">5.04 K</td>
    <td style="white-space: nowrap; text-align: right">9.93x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.45 K</td>
    <td style="white-space: nowrap; text-align: right">14.51x</td>
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
    <td style="white-space: nowrap">16.72 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">19.91 KB</td>
    <td>1.19x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.39 KB</td>
    <td>1.34x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">13.38 KB</td>
    <td>0.8x</td>
  </tr>
</table>



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
    <td style="white-space: nowrap; text-align: right">868.56 K</td>
    <td style="white-space: nowrap; text-align: right">1.15 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;153.14%</td>
    <td style="white-space: nowrap; text-align: right">1.10 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.50 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">464.40 K</td>
    <td style="white-space: nowrap; text-align: right">2.15 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;52.08%</td>
    <td style="white-space: nowrap; text-align: right">2.10 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">2.50 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">65.05 K</td>
    <td style="white-space: nowrap; text-align: right">15.37 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;46.10%</td>
    <td style="white-space: nowrap; text-align: right">15 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">17 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">4.74 K</td>
    <td style="white-space: nowrap; text-align: right">210.80 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;19.81%</td>
    <td style="white-space: nowrap; text-align: right">208 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">303 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">868.56 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">464.40 K</td>
    <td style="white-space: nowrap; text-align: right">1.87x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">65.05 K</td>
    <td style="white-space: nowrap; text-align: right">13.35x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">4.74 K</td>
    <td style="white-space: nowrap; text-align: right">183.1x</td>
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
    <td style="white-space: nowrap">30.32 KB</td>
    <td>53.16x</td>
  </tr>
</table>


