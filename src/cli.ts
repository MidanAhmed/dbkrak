import { Command } from "commander";
import { registerDiffCommand } from "./commands/diff";
import { registerMigrateCommand } from "./commands/migrate";
import { registerSyncDataCommand } from "./commands/sync-data";

const program = new Command();
program
  .name("krakenn")
  .description("Intelligent DB schema and data sync tool")
  .version("0.1.0");

registerDiffCommand(program);
registerMigrateCommand(program);
registerSyncDataCommand(program);

program.parse(process.argv);
