import { Dotly }  from '../core/Dotly.ts'

await Dotly.script('name', 'documentation', ['arg'], (args: object) => {
  console.log(args)
})
