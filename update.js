(async function () {
	// initializing database access to process.env
	require("./db-access.js");

	await require("../modules/supi-core")("sb", {
		whitelist: [
			"objects/date",
			"objects/error",
			"singletons/query",
		]
	});

	const save = require("./save.js");
	const processes = [
		{
			path: "./commands/",
			directories: ["./commands", "./commands/archived"],
			filenameColumn: "Name",
			database: "chat_data",
			table: "Command",
			Query: sb.Query,
			extraPathFunction: (row) => (row.Flags?.includes("archived")) ? "archived/" : ""
		},
		{
			path: "./crons/",
			directories: ["./crons", "./crons/inactive"],
			filenameColumn: "Name",
			database: "chat_data",
			table: "Cron",
			Query: sb.Query,
			extraPathFunction: (row) => (row.Active) ? "" : "inactive/"
		},
		{
			path: "./got-instances/",
			directories: ["./got-instances"],
			filenameColumn: "Name",
			database: "data",
			table: "Got_Instance",
			Query: sb.Query
		},
		{
			path: "./slots-patterns/",
			directories: ["./slots-patterns"],
			filenameColumn: "Name",
			database: "data",
			table: "Slots_Pattern",
			Query: sb.Query
		},
		{
			path: "./extra-news/",
			directories: ["./extra-news"],
			filenameColumn: "Code",
			database: "data",
			table: "Extra_News",
			ignoredColumns: ["Helpers"],
			Query: sb.Query
		}
	];
	
	await Promise.all(processes.map(i => save(i)));
	console.log("All done!");
	process.exit();
})();