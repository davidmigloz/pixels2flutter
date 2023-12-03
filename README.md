# [pixels2flutter.dev](https://pixels2flutter.dev) 🦋

[![tests](https://img.shields.io/github/actions/workflow/status/davidmigloz/pixels2flutter/deploy.yaml?logo=github&label=deploy)](https://github.com/davidmigloz/pixels2flutter/actions/workflows/deploy.yaml)
[![](https://dcbadge.vercel.app/api/server/x4qbhqecVR?style=flat)](https://discord.gg/x4qbhqecVR)
[![AGPL-3.0](https://img.shields.io/badge/license-AGPL--3.0-purple.svg)](https://github.com/davidmigloz/pixels2flutter/blob/main/LICENSE)

Convert a screenshot to Flutter code!

## How does it work

https://github.com/davidmigloz/pixels2flutter/assets/6546265/a6e4101c-98eb-4adf-b0b9-ae37af3f2ccc

**1. Upload a screenshot**

Select or drag and drop a screenshot of the UI you want to convert to Flutter.
It can be from a real app, a design, or even a drawing!

**2. Additional instructions**

Optionally, add some extra instructions to help the AI generate the code.
For example, how the UI should behave when the user interacts with it.

**3. Code generation**

The app leverages the power of OpenAI GPT-4V(ision) multimodal LLM to transform
your screenshot and instructions into code.

**4. Run the code**

The generated code is stored in a GitHub Gist and loaded into DartPad.
So you can run the resulting Flutter app right from the browser!

## Examples

<table>
  <tr>
    <td colspan="2"><p align="center"><strong>Screenshot</strong><br> Convert a screenshot of a real app to Flutter code.</p></td>
  </tr>
  <tr>
    <td><p align="center"><img width="200" src="https://github.com/davidmigloz/pixels2flutter/assets/6546265/4670669a-7617-49b8-9521-0c42907110e9"></p></td>
    <td><p align="center"><img width="200" src="https://github.com/davidmigloz/pixels2flutter/assets/6546265/d83cd79e-fdf2-419f-a8de-a22ef2c9d576"></p></td>
  </tr>
  <tr>
    <td colspan="2"><p align="center"><strong>Wireframe</strong><br> Convert a wireframe to Flutter code.</p></td>
  </tr>
  <tr>
    <td><p align="center"><img width="400" src="https://github.com/davidmigloz/pixels2flutter/assets/6546265/467736e6-b01a-4ea2-b63b-d8f3228e79a3"></p></td>
    <td><p align="center"><img width="200" src="https://github.com/davidmigloz/pixels2flutter/assets/6546265/bf00a7f8-797e-4667-b36f-75a1269e90c8"></p></td>
  </tr>
  <tr>
    <td colspan="2"><p align="center"><strong>Game</strong><br> Convert a screenshot of a game plus a description of its logic to a playable Flutter game.</p></td>
  </tr>
  <tr>
    <td><p align="center"><img width="350" src="https://github.com/davidmigloz/pixels2flutter/assets/6546265/643ad122-af6e-4b59-8ce0-001a1c7e5c66"></p></td>
    <td><p align="center"><img width="350" src="https://github.com/davidmigloz/pixels2flutter/assets/6546265/0d2aa09c-0efb-40bb-b4d8-e7986d17c48b"></p></td>
  </tr>
</table>

## Acknowledgements

This project is inspired by:
- [tldraw/make-real](https://github.com/tldraw/make-real)
- [abi/screenshot-to-code](https://github.com/abi/screenshot-to-code)

## License

pixels2flutter.dev is licensed under the [AGPL-3.0 license](https://github.com/davidmigloz/pixels2flutter/blob/main/LICENSE).
