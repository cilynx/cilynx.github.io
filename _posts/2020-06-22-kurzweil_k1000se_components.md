---
layout: post
title:  Kurzweil K1000SE Components
date:   2020-06-22 20:23:39 -0700
tags:   kurzweil k1000 synth
---
![K1000SE Arnold Chips](/assets/20200620_160627.jpg)

## Table of Contents
* TOC
{:toc}


## Headers & Harnesses
Diagrams created with [WireViz](https://github.com/formatc1702/WireViz).

### Power Block <-> Transformer
[Schematic](/assets/8-10_K1000 Power supply %28PSK-57%29.jpg) |
[Photograph](/assets/20200625_190444.jpg)
![PSU-CPU Harness](/assets/k1000se_powerblock-transformer.svg)
```yml
connectors:
   Power Block Mains:
      pinout: [Hot, Neutral]
   Power Block J2:
      pinout: [P2-1, P2-2, P2-3, P2-4, P2-5, P2-6, P2-7, P2-8, P2-9]
   Transformer:
      pinout: [GND, 100Vac, 120Vac, 220Vac, 240Vac]
   Power Switch:
      pinout: [A, B]
   Voltage Selector:
      pinout: [100Vac, 120Vac, 220Vac, 240Vac, Input]

cables:
   W1:
      colors: [WH, BU, GN, YE, OG]
   Power Block Traces:
      colors: [BU, GN, YE, OG]
   Power Block Trace:
      colors: [BK]
   W2:
      colors: [GY,BN]

connections:
   -
      - Transformer: [1,2,3,4,5]
      - W1: [1-5]
      - Power Block J2: [1,3,4,6,7]
   -
      - Voltage Selector: [1-4]
      - Power Block Traces: [1-4]
      - Power Block J2: [3,4,6,7]
   -
      - Voltage Selector: [5]
      - Power Block Trace: [1]
      - Power Block Mains: [1]
   -
      - Power Switch: [1]
      - W2: [1]
      - Power Block J2: [9]
   -
      - Power Switch: [2]
      - W2: [2]
      - Power Block Mains: [2]
```

### PSU <-> CPU
[Schematic](/assets/8-10_K1000 Power supply %28PSK-57%29.jpg)
![PSU-CPU Harness](/assets/k1000se_psu-cpu.svg)
```yml
connectors:
   PSU J2:
      pinout: [+5V (Backup), PCK, RESET, GND (Digital), GND (Digital), +5V, +5V, +12V, GND (Analog), -12V]
   CPU J4:
      pinout: [GND (Digital), GND (Digital), +5V, +12V, -12V, GND (Analog), +5V (Backup), +5V, PCK, RESET]

cables:
   W1:
      wirecount: 10
      colors: [BK, BK, RD, BU, OG, BK, RD, RD, VT, YE]

connections:
   -
      - CPU J4: [1-10]
      - W1: [1-10]
      - PSU J2: [4,5,6,8,10,9,1,7,2,3]
```

## Chips

|Position|Part Number|Description|Mount|Picture|
|---|
|<a name='U1' href='#U1'>U1</a>|[M74LS244P](/assets/M74LS244P.pdf)|Octal Buffer / Line Driver|Fixed|[Picture](/assets/20200620_103012.jpg)|
|<a name='U2' href='#U2'>U2</a>|[M74LS273P](/assets/M74LS273P.pdf)|Octal Flip Flop|Fixed|[Picture](/assets/20200620_103025.jpg)|
|<a name='U3' href='#U3'>U3</a>|[SN74S04N](/assets/SN74S04N.pdf)|Hex Inverters|Fixed|[Picture](/assets/20200622_192620.jpg)|
|<a name='U4' href='#U4'>U4</a>|[M74ALS32P](/assets/M74ALS32P.pdf)|Quad 2-Input Positive OR Gates|Fixed|[Picture](/assets/20200620_103025.jpg)|
|<a name='U5' href='#U5'>U5</a>|[M74LS138P](/assets/M74LS138P.pdf)|3-to-8 Decoder / Demultiplexer|Fixed|[Picture](/assets/20200620_103025.jpg)|
|<a name='U6' href='#U6'>U6</a>|[M74LS04P](/assets/M74LS04P.pdf)|Hex Inverters|Fixed|[Picture](/assets/20200620_103025.jpg)|
|<a name='U7' href='#U7'>U7</a>|[74F112PC](/assets/74F112PC.pdf)|Dual JK LE Flip Flop|Fixed|[Picture](/assets/20200622_192620.jpg)|
|<a name='U8' href='#U8'>U8</a>|[PALC22V10-35PC](/assets/PALC22V10-35PC.pdf)|CMOS Programmable Array Logic|Socket|[Picture](/assets/20200620_103025.jpg)|
|<a name='U9' href='#U9'>U9</a>|[M74LS244P](/assets/M74LS244P.pdf)|Octal Buffer / Line Driver|Fixed|[Picture](/assets/20200620_103025.jpg)|
|<a name='U10' href='#U10'>U10</a>|[M5216](/assets/M5216.pdf)|Dual Op-Amp|Fixed|[Picture](/assets/20200620_165144.jpg)|
|<a name='U11' href='#U11'>U11</a>|[M74LS244P](/assets/M74LS244P.pdf)|Octal Buffer / Line Driver|Fixed||
|<a name='U12' href='#U12'>U12</a>|[M74LS244P](/assets/M74LS244P.pdf)|Octal Buffer / Line Driver|Fixed|[Picture](/assets/20200620_160542.jpg)|
|<a name='U13' href='#U13'>U13</a>|[74F08PC](/assets/74F08PC.pdf)|Quad 2-Input AND Gate|Fixed|[Picture](/assets/20200622_192620.jpg)|
|<a name='U14' href='#U14'>U14</a>|[M74ALS151AP](/assets/M74ALS151AP.pdf)|1-of-8 Data Selector / Multiplexer|Fixed|[Picture](/assets/20200620_103025.jpg)|
|<a name='U15' href='#U15'>U15</a>|[M74ALS32P](/assets/M74ALS32P.pdf)|Quad 2-Input Positive OR Gates|Fixed|[Picture](/assets/20200620_103025.jpg)|
|<a name='U16' href='#U16'>U16</a>|[KMS66000101A](/assets/KMS66000101A.pdf)|Arnold Chip (KMS Proprietary?)|Socket|[Picture](/assets/20200620_160542.jpg)|
|<a name='U17' href='#U17'>U17</a>|[MC68000P10](/assets/MC68000P10.pdf)|10MHz CPU|Fixed||
|<a name='U18' href='#U18'>U18</a>|[C4072C](/assets/C4072C.pdf)|J-FET Input Dual Op-Amp|Fixed|[Picture](/assets/20200620_165144.jpg)|
|<a name='U19' href='#U19'>U19</a>|[D43256AC-15L](/assets/D43256AC-15L.pdf)|32K RAM|Fixed|[Picture](/assets/20200620_103012.jpg)|
|<a name='U20' href='#U20'>U20</a>|[](/assets/.pdf)||||
|<a name='U21' href='#U21'>U21</a>|[M5M27C101K-2](/assets/M5M27C101K-2.pdf)|Software Engine EPROM (HI)|Socket||
|<a name='U22' href='#U22'>U22</a>|[](/assets/.pdf)||||
|<a name='U23' href='#U23'>U23</a>|[M74LS244P](/assets/M74LS244P.pdf)|Octal Buffer / Line Driver|Fixed|[Picture](/assets/20200620_165153.jpg)|
|<a name='U24' href='#U24'>U24</a>|[M74LS244P](/assets/M74LS244P.pdf)|Octal Buffer / Line Driver|Fixed|[Picture](/assets/20200620_165200.jpg)|
|<a name='U25' href='#U25'>U25</a>|[74F175PC](/assets/74F175PC.pdf)|Quad D-Type Flip-Flop|Fixed|[Picture](/assets/20200622_192620.jpg)|
|<a name='U26' href='#U26'>U26</a>|[74F374PC](/assets/74F374PC.pdf)|Octal D-Type Flip-Flop with 3-STATE Outputs|Fixed|[Picture](/assets/20200622_192620.jpg)|
|<a name='U27' href='#U27'>U27</a>|[M74ALS02P](/assets/M74ALS02P.pdf)|Quad 2-Input Positive NOR Gate|Fixed|[Picture](/assets/20200622_192620.jpg)|
|<a name='U28' href='#U28'>U28</a>|[SN74S04N](/assets/SN74S04N.pdf)|Hex Inverters|Fixed|[Picture](/assets/20200622_192620.jpg)|
|<a name='U29' href='#U29'>U29</a>|[KMS66000101A](/assets/KMS66000101A.pdf)|Arnold Chip (KMS Proprietary?)|Socket|[Picture](/assets/20200620_160542.jpg)|
|<a name='U30' href='#U30'>U30</a>|[D43256AC-15L](/assets/D43256AC-15L.pdf)|32K RAM|Fixed|[Picture](/assets/20200620_103012.jpg)|
|<a name='U31' href='#U31'>U31</a>|[](/assets/.pdf)||||
|<a name='U32' href='#U32'>U32</a>|[M5M27C101K-2](/assets/M5M27C101K-2.pdf)|Software Engine EPROM (LO)|Socket||
|<a name='U33' href='#U33'>U33</a>|[](/assets/.pdf)||||
|<a name='U34' href='#U34'>U34</a>|[M74LS245P](/assets/M74LS245P.pdf)|Octal Bus Transciever|Fixed||
|<a name='U35' href='#U35'>U35</a>|[M74LS244P](/assets/M74LS244P.pdf)|Octal Buffer / Line Driver|Fixed|[Picture](/assets/20200620_165150.jpg)|
|<a name='U36' href='#U36'>U36</a>|[M74LS244P](/assets/M74LS244P.pdf)|Octal Buffer / Line Driver|Fixed|[Picture](/assets/20200620_165150.jpg)|
|<a name='U37' href='#U37'>U37</a>|[M74ALS244AP](/assets/M74ALS244AP.pdf)|Octal Buffer / Line Driver|Fixed|[Picture](/assets/20200620_160627.jpg)|
|<a name='U38' href='#U38'>U38</a>|[](/assets/.pdf)||||
|<a name='U39' href='#U39'>U39</a>|[M74LS245P](/assets/M74LS245P.pdf)|Octal Bus Transciever|Fixed|[Picture](/assets/20200620_165153.jpg)|
|<a name='U40' href='#U40'>U40</a>|[M74LS244P](/assets/M74LS244P.pdf)|Octal Buffer / Line Driver|Fixed|[Picture](/assets/20200620_103012.jpg)|
|<a name='U41' href='#U41'>U41</a>|[M74LS257AP](/assets/M74LS257AP.pdf)|Quad Multiplexer|Fixed|[Picture](/assets/20200620_165150.jpg)|
|<a name='U42' href='#U42'>U42</a>|[M74LS257AP](/assets/M74LS257AP.pdf)|Quad Multiplexer|Fixed|[Picture](/assets/20200620_165150.jpg)|
|<a name='U43' href='#U43'>U43</a>|[M74LS257AP](/assets/M74LS257AP.pdf)|Quad Multiplexer|Fixed|[Picture](/assets/20200620_165150.jpg)|
|<a name='U44' href='#U44'>U44</a>|[](/assets/.pdf)|||[Picture](/assets/20200620_103025.jpg)|
|<a name='U45' href='#U45'>U45</a>|[M74LS02P](/assets/M74LS02P.pdf)|Quad 2-Input NOR Gate|Fixed|[Picture](/assets/20200622_192620.jpg)|
|<a name='U46' href='#U46'>U46</a>|[](/assets/.pdf)||||
|<a name='U47' href='#U47'>U47</a>|[](/assets/.pdf)||||
|<a name='U48' href='#U48'>U48</a>|[HD63B40P](/assets/HD63B40P.pdf)|2MHz Programmable Timer Module|Fixed||
|<a name='U49' href='#U49'>U49</a>|[M74ALS138P](/assets/M74ALS138P.pdf)|3-to-8 Decoder / Demultiplexer|Fixed|[Picture](/assets/20200622_192620.jpg)|
|<a name='U50' href='#U50'>U50</a>|[A00100Y-02](/assets/A00100Y-02.pdf)|Sound EPROM (Stock)|Socket|[Picture](/assets/20200620_082127.jpg)|
|<a name='U51' href='#U51'>U51</a>|[A00200Y-02](/assets/A00200Y-02.pdf)|Sound EPROM (Stock)|Socket|[Picture](/assets/20200620_082127.jpg)|
|<a name='U52' href='#U52'>U52</a>|[[Empty]](/assets/[Empty].pdf)|Sound EPROM (Upgrade)|Socket|[Picture](/assets/20200620_082127.jpg)|
|<a name='U53' href='#U53'>U53</a>|[[Empty]](/assets/[Empty].pdf)|Sound EPROM (Upgrade)|Socket|[Picture](/assets/20200620_082127.jpg)|
|<a name='U54' href='#U54'>U54</a>|[A00100Z-03](/assets/A00100Z-03.pdf)|Sound EPROM (Stock)|Socket|[Picture](/assets/20200620_082127.jpg)|
|<a name='U55' href='#U55'>U55</a>|[A00200Z-03](/assets/A00200Z-03.pdf)|Sound EPROM (Stock)|Socket|[Picture](/assets/20200620_082127.jpg)|
|<a name='U56' href='#U56'>U56</a>|[[Empty]](/assets/[Empty].pdf)|Sound EPROM (Upgrade)|Socket|[Picture](/assets/20200620_082127.jpg)|
|<a name='U57' href='#U57'>U57</a>|[[Empty]](/assets/[Empty].pdf)|Sound EPROM (Upgrade)|Socket|[Picture](/assets/20200620_082127.jpg)|
|<a name='U58' href='#U58'>U58</a>|[A00100X-01](/assets/A00100X-01.pdf)|Sound EPROM (Stock)|Socket|[Picture](/assets/20200620_082127.jpg)|
|<a name='U59' href='#U59'>U59</a>|[A00200X-01](/assets/A00200X-01.pdf)|Sound EPROM (Stock)|Socket|[Picture](/assets/20200620_082127.jpg)|
|<a name='U60' href='#U60'>U60</a>|[[Empty]](/assets/[Empty].pdf)|Sound EPROM (Upgrade)|Socket|[Picture](/assets/20200620_082127.jpg)|
|<a name='U61' href='#U61'>U61</a>|[[Empty]](/assets/[Empty].pdf)|Sound EPROM (Upgrade)|Socket|[Picture](/assets/20200620_082127.jpg)|
|<a name='U62' href='#U62'>U62</a>|[C4570C](/assets/C4570C.pdf)|Dual OpAmp|Fixed|[Picture](/assets/20200622_200914.jpg)|
|<a name='U63' href='#U63'>U63</a>|[C4570C](/assets/C4570C.pdf)|Dual OpAmp|Fixed|[Picture](/assets/20200620_160627.jpg)|
|<a name='U64' href='#U64'>U64</a>|[M74LS74AP](/assets/M74LS74AP.pdf)|Dual D-Type Positive Flip-Flops|Fixed|[Picture](/assets/20200622_192620.jpg)|
|<a name='U65' href='#U65'>U65</a>|[PCM56P](/assets/PCM56P.pdf)|16-bit DAC|Socket|[Picture](/assets/20200620_160627.jpg)|
|<a name='U66' href='#U66'>U66</a>|[PCM56P](/assets/PCM56P.pdf)|16-bit DAC|Socket|[Picture](/assets/20200620_160627.jpg)|
|<a name='U67' href='#U67'>U67</a>|[MC68B50P](/assets/MC68B50P.pdf)|Asynchronous Communications Interface Adaptor|Fixed||
|<a name='U68' href='#U68'>U68</a>|[M74LS367AP](/assets/M74LS367AP.pdf)|Hex Bus Driver|Fixed||
|<a name='U69' href='#U69'>U69</a>|[](/assets/.pdf)||||
|<a name='U70' href='#U70'>U70</a>|[M74LS165AP](/assets/M74LS165AP.pdf)|8-Bit Parallel-In Serial-Out Shift Register|Fixed|[Picture](/assets/20200622_192620.jpg)|
|<a name='U71' href='#U71'>U71</a>|[](/assets/.pdf)||||
|<a name='U72' href='#U72'>U72</a>|[](/assets/.pdf)||||
|<a name='U73' href='#U73'>U73</a>|[](/assets/.pdf)||||
|<a name='U74' href='#U74'>U74</a>|[](/assets/.pdf)||||
|<a name='U75' href='#U75'>U75</a>|[](/assets/.pdf)||||
|<a name='U76' href='#U76'>U76</a>|[](/assets/.pdf)||||
|<a name='U77' href='#U77'>U77</a>|[](/assets/.pdf)||||
|<a name='U78' href='#U78'>U78</a>|[](/assets/.pdf)||||
|<a name='U79' href='#U79'>U79</a>|[](/assets/.pdf)||||
|<a name='U80' href='#U80'>U80</a>|[](/assets/.pdf)||||
|<a name='U81' href='#U81'>U81</a>|[](/assets/.pdf)||||
|<a name='U82' href='#U82'>U82</a>|[](/assets/.pdf)||||
|<a name='U83' href='#U83'>U83</a>|[](/assets/.pdf)||||
|<a name='U84' href='#U84'>U84</a>|[](/assets/.pdf)||||
|<a name='U85' href='#U85'>U85</a>|[](/assets/.pdf)||||
|<a name='U86' href='#U86'>U86</a>|[](/assets/.pdf)||||
|<a name='U87' href='#U87'>U87</a>|[](/assets/.pdf)||||
|<a name='U88' href='#U88'>U88</a>|[](/assets/.pdf)||||
|<a name='U89' href='#U89'>U89</a>|[](/assets/.pdf)||||
|<a name='U90' href='#U90'>U90</a>|[](/assets/.pdf)||||
|<a name='U91' href='#U91'>U91</a>|[](/assets/.pdf)||||
|<a name='U92' href='#U92'>U92</a>|[](/assets/.pdf)||||
|<a name='U93' href='#U93'>U93</a>|[](/assets/.pdf)||||
|<a name='U94' href='#U94'>U94</a>|[](/assets/.pdf)||||
|<a name='U95' href='#U95'>U95</a>|[](/assets/.pdf)||||
|<a name='U96' href='#U96'>U96</a>|[](/assets/.pdf)||||
|<a name='U97' href='#U97'>U97</a>|[](/assets/.pdf)||||
|<a name='U98' href='#U98'>U98</a>|[](/assets/.pdf)||||
|<a name='U99' href='#U99'>U99</a>|[](/assets/.pdf)||||
|<a name='U100' href='#U100'>U100</a>|[](/assets/.pdf)||||
|<a name='U101' href='#U101'>U101</a>|[](/assets/.pdf)||||
|<a name='U102' href='#U102'>U102</a>|[MC68B50P](/assets/MC68B50P.pdf)|Asynchronous Communications Interface Adaptor|Fixed||
