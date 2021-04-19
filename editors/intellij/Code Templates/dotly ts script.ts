import { Dotly } from '../core/Dotly.ts'
import { Args }  from '../core/Args.ts'

await Dotly.script('Documentation', async (args: Args) => {
  console.log(args)
})
