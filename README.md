# Wind Turbines relaunched
## Features
Wind Turbines produce free energy, but are expensive to build and don't have a steady output.
This mod adds 4 tiers of turbines, from a small wooden windmill to a giant steel and refined concrete turbine.

![wind turbines](https://github.com/xyzzycgn/Wind-Turbines-relaunched/blob/main/turbines.jpg?raw=true)
- Alternative/complement to solar panel arrays, similar large upfront cost but free energy after
- The higher tier versions save a lot of space compared to solar panel arrays
- You can walk around the base tower, but you cannot build there to avoid objects getting hidden behind the 
  large graphics (depends on settings)

## Configuration options
There are several options you can use to configure behaviour of this mod.
- Wind strength factor  
  Multiplier for energy production. Allowed range is 1 - 10, defaults to 1.

- Enable the Giant turbine  
  Allows disabling the Giant wind turbine for low-end computers where the large graphics might cause problems. 
  Giant wind turbine is enabled by default.

- Determination of wind strength (since version 2.1.1, extended from 2.1.0)  
  Here you can choose how this mod calculates the wind strength (and thus the energy yield). There are three different modes:
  - classical  
    Use of the original (periodic) function with identical values of wind strength on all surfaces
  - surface  
    Uses wind strength determined by the surface (individual for each surface) changing in a more random based manner
  - surface + pressure (new in 2.1.1) 
    Wind strength is determined like in mode _surface_, but additionally the energy yield is influenced by atmospheric 
    pressure of the planet/moon (increases at higher pressure and decreases at lower pressure). The change is based on 
    the ratio of air pressure compared to nauvis. This is the default.

- Wind turbines take up more space (since version 2.1.0)    
  If enabled, the space behind the wind turbines is reserved, so that nothing can be built there (classical behaviour, 
  **disabled** by default).

- higher construction costs (since version 2.2.1)
  If enabled, construction of turbines requires more resources (disabled by default)


## Quality
Quality (introduced by SPA) is supported. The different quality tiers offer increased health and energy output.
Increase of energy output is analogous to that of a solar panel.

## Supported locales
As of version 2.0.1 several locales are supported. Currently these are:
- čeština (cs)
- deutsch (de)
- ελληνικά (el)
- english (en) - default
- español (es-ES)
- suomi (fi)
- français (fr)
- magyar (hu)
- italiano (it)
- 日本語 (ja)
- 한국인 (ko)
- nederlands (nl)
- norsk (no)
- polski (pl)
- português (pt-BR)
- русский (ru)
- svenska (sv-SE)
- türkçe (tr)
- українська (uk-UA)
- 中国人 (zh-CN)
- 中國人 (zh-TW)

## Contributors
- Onseshigo: adjustments in locale ru

----
## Relaunch of Wind Turbines from wavtrex with the necessary patches for V 2.0 of factorio.
This mod is intended as inplace replacement for [Wind_Generator-gfxrestyle](https://mods.factorio.com/mod/Wind_Generator-gfxrestyle) 
which is no longer compatible with V 2.0 of factorio.
