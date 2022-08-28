
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
    <td style="white-space: nowrap">25.0</td>
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
    <td style="white-space: nowrap; text-align: right">2.01 M</td>
    <td style="white-space: nowrap; text-align: right">0.50 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;8097.54%</td>
    <td style="white-space: nowrap; text-align: right">0.38 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.38 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.52 M</td>
    <td style="white-space: nowrap; text-align: right">0.66 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4063.42%</td>
    <td style="white-space: nowrap; text-align: right">0.58 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.75 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0143 M</td>
    <td style="white-space: nowrap; text-align: right">70.00 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;7.42%</td>
    <td style="white-space: nowrap; text-align: right">69.17 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">78.83 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00578 M</td>
    <td style="white-space: nowrap; text-align: right">172.98 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;20.00%</td>
    <td style="white-space: nowrap; text-align: right">173.08 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">263.95 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">2.01 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.52 M</td>
    <td style="white-space: nowrap; text-align: right">1.32x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0143 M</td>
    <td style="white-space: nowrap; text-align: right">140.4x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00578 M</td>
    <td style="white-space: nowrap; text-align: right">346.92x</td>
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
    <td style="white-space: nowrap">118.67 KB</td>
    <td>174.6x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">24.20 KB</td>
    <td>35.61x</td>
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
    <td style="white-space: nowrap; text-align: right">3.35 M</td>
    <td style="white-space: nowrap; text-align: right">0.30 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;14334.00%</td>
    <td style="white-space: nowrap; text-align: right">0.21 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.33 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">2.15 M</td>
    <td style="white-space: nowrap; text-align: right">0.46 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;6692.91%</td>
    <td style="white-space: nowrap; text-align: right">0.38 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.25 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0485 M</td>
    <td style="white-space: nowrap; text-align: right">20.62 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;17.02%</td>
    <td style="white-space: nowrap; text-align: right">20.54 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">23.67 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00578 M</td>
    <td style="white-space: nowrap; text-align: right">172.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;31.20%</td>
    <td style="white-space: nowrap; text-align: right">172.20 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">263.16 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">3.35 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">2.15 M</td>
    <td style="white-space: nowrap; text-align: right">1.56x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0485 M</td>
    <td style="white-space: nowrap; text-align: right">69.16x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00578 M</td>
    <td style="white-space: nowrap; text-align: right">580.07x</td>
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
    <td style="white-space: nowrap">2.84 KB</td>
    <td>7.28x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.70 KB</td>
    <td>58.12x</td>
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
    <td style="white-space: nowrap; text-align: right">3.30 M</td>
    <td style="white-space: nowrap; text-align: right">0.30 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;13424.38%</td>
    <td style="white-space: nowrap; text-align: right">0.21 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.38 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">2.21 M</td>
    <td style="white-space: nowrap; text-align: right">0.45 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;7637.10%</td>
    <td style="white-space: nowrap; text-align: right">0.38 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.50 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0469 M</td>
    <td style="white-space: nowrap; text-align: right">21.33 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;26.96%</td>
    <td style="white-space: nowrap; text-align: right">21.08 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">24.75 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00586 M</td>
    <td style="white-space: nowrap; text-align: right">170.70 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;20.06%</td>
    <td style="white-space: nowrap; text-align: right">169.54 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">258.14 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">3.30 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">2.21 M</td>
    <td style="white-space: nowrap; text-align: right">1.49x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0469 M</td>
    <td style="white-space: nowrap; text-align: right">70.34x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00586 M</td>
    <td style="white-space: nowrap; text-align: right">562.96x</td>
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
    <td style="white-space: nowrap">5.20 KB</td>
    <td>11.67x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.78 KB</td>
    <td>51.16x</td>
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
    <td style="white-space: nowrap; text-align: right">104.88 K</td>
    <td style="white-space: nowrap; text-align: right">9.53 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;301.60%</td>
    <td style="white-space: nowrap; text-align: right">8.96 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">29.37 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">104.15 K</td>
    <td style="white-space: nowrap; text-align: right">9.60 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;45.54%</td>
    <td style="white-space: nowrap; text-align: right">9.33 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">14.25 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">5.78 K</td>
    <td style="white-space: nowrap; text-align: right">172.93 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;21.13%</td>
    <td style="white-space: nowrap; text-align: right">172.24 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">265.38 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.35 K</td>
    <td style="white-space: nowrap; text-align: right">298.47 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;23.06%</td>
    <td style="white-space: nowrap; text-align: right">336.82 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">363.07 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">104.88 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap; text-align: right">104.15 K</td>
    <td style="white-space: nowrap; text-align: right">1.01x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">5.78 K</td>
    <td style="white-space: nowrap; text-align: right">18.14x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">3.35 K</td>
    <td style="white-space: nowrap; text-align: right">31.3x</td>
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
    <td style="white-space: nowrap">16.52 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">time_zone_info</td>
    <td style="white-space: nowrap">19.75 KB</td>
    <td>1.2x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">22.70 KB</td>
    <td>1.37x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap">13.11 KB</td>
    <td>0.79x</td>
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
    <td style="white-space: nowrap; text-align: right">1.60 M</td>
    <td style="white-space: nowrap; text-align: right">0.62 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;5090.00%</td>
    <td style="white-space: nowrap; text-align: right">0.54 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.71 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.50 M</td>
    <td style="white-space: nowrap; text-align: right">0.66 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4323.18%</td>
    <td style="white-space: nowrap; text-align: right">0.58 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.75 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0696 M</td>
    <td style="white-space: nowrap; text-align: right">14.38 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;168.76%</td>
    <td style="white-space: nowrap; text-align: right">14.12 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">17.17 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00538 M</td>
    <td style="white-space: nowrap; text-align: right">185.94 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;28.37%</td>
    <td style="white-space: nowrap; text-align: right">184.16 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">276.59 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">1.60 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tz</td>
    <td style="white-space: nowrap; text-align: right">1.50 M</td>
    <td style="white-space: nowrap; text-align: right">1.07x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">tzdata</td>
    <td style="white-space: nowrap; text-align: right">0.0696 M</td>
    <td style="white-space: nowrap; text-align: right">23.07x</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap; text-align: right">0.00538 M</td>
    <td style="white-space: nowrap; text-align: right">298.41x</td>
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
    <td style="white-space: nowrap">2.84 KB</td>
    <td>4.99x</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">zoninfo</td>
    <td style="white-space: nowrap">30.33 KB</td>
    <td>53.18x</td>
  </tr>
</table>


