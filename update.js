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
			path: "C:\\Projects\\supibot-sql\\commands\\",
			filenameColumn: "Name",
			database: "chat_data",
			table: "Command",
			Query: sb.Query,
			extraPathFunction: (row) => (row.Archived) ? "archived\\" : ""
		},
		{
			path: "C:\\Projects\\supibot-sql\\crons\\",
			filenameColumn: "Name",
			database: "chat_data",
			table: "Cron",
			Query: sb.Query,
			extraPathFunction: (row) => (row.Active) ? "" : "inactive\\"
		},
		{
			path: "C:\\Projects\\supibot-sql\\got-instances\\",
			filenameColumn: "Name",
			database: "data",
			table: "Got_Instance",
			Query: sb.Query
		},
		{
			path: "C:\\Projects\\supibot-sql\\slots-patterns\\",
			filenameColumn: "Name",
			database: "data",
			table: "Slots_Pattern",
			Query: sb.Query
		},
		{
			path: "C:\\Projects\\supibot-sql\\extra-news\\",
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