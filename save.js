module.exports = async function save (options) {
	if (!options.Query) {
		throw new Error("Database access not initialized!");
	}

	const { access, mkdir } = require("fs/promises");
	for (const path of options.directories) {
		try {
			await access(path);
		}
		catch {
			await mkdir(path);
		}
	}	

	const { ignoredColumns = [], Query } = options;
	const columnData = await Query.getRecordset(rs => rs
		.select("COLUMN_NAME AS `Column`", "DATA_TYPE AS `Type`")
		.from("information_schema", "COLUMNS")
		.where("TABLE_SCHEMA = %s", options.database)
		.where("TABLE_NAME = %s", options.table)
	);

	const columnNames = columnData
		.map(i => i.Column)
		.filter(i => !ignoredColumns.includes(i));
		
	const rows = await Query.getRecordset(rs => rs
		.select("*")
		.from(options.database, options.table)
	);

	const types = columnData.map(i => {
		let type = i.Type;

		type = type.toUpperCase();
		if (type === "TINYINT") {
			type = "TINY";
		}

		return type;
	});

	const promises = [];
	const save = require("util").promisify(require("fs").writeFile);

	for (const row of rows) {
		const values = columnNames.map((name, index) => Query.convertToSQL(row[name], types[index]));

		let extraPath = "";
		if (typeof options.extraPathFunction === "function") {
			extraPath = options.extraPathFunction(row) ?? "";
		}

		promises.push(save(
			options.path + extraPath + row[options.filenameColumn] + ".sql",
			[
				"INSERT INTO",
				`\t\`${options.database}\`.\`${options.table}\``,
				"\t(",
				columnNames.map(i => `\t\t${i}`).join(",\n"),
				"\t)",
				"VALUES",
				"\t(",
				values.map(i => `\t\t${i}`).join(",\n"),
				"\t)"
			].join("\n")
		));
	}

	await Promise.all(promises);
	console.log(`Saved all ${options.database}.${options.table}`);
};