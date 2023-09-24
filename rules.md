# Theme

- 'theme.lua' file should mostly be responsible for changing colors and fonts. In previous config everything ( border widths, margins, spacings ) was put there and it was a mess. Another points is that things other than colors and font won't be changed offen
- Each widget must contain its own theme definition, so widget specific theme definitions wont polute 'theme.lua'
