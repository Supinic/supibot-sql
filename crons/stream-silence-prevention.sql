INSERT INTO
	`chat_data`.`Cron`
	(
		ID,
		Name,
		Expression,
		Description,
		Defer,
		Code,
		Type,
		Active
	)
VALUES
	(
		20,
		'stream-silence-prevention',
		'*/10 * * * * *',
		'Makes sure that there is not a prolonged period of song request silence on Supinic\'s stream while live.',
		NULL,
		'(async function preventStreamSilence () {
	if (this.data.stopped) {
		return;
	}

	const channelData = sb.Channel.get(\"supinic\", \"twitch\");
	if (!channelData.sessionData.live) {
		return;
	}

	const state = sb.Config.get(\"SONG_REQUESTS_STATE\");
	if (state !== \"vlc\") {
		return;
	}

	const queue = await sb.VideoLANConnector.getNormalizedPlaylist();
	if (queue.length !== 0) {
		return;
	}

	const links = [\"rPxbaEIp-_w\",\"9jB9-zMj-QU\",\"SEVWJkKmXWE\",\"pdHZKgQvpQk\",\"tPgJqxX4kgA\",\"VsL-bA587Y4\",\"EM9nIJzsaxs\",\"j_jE8Wq25nk\",\"VBcHzpX0MOM\",\"HX1XWwq5Pjg\",\"N3z9TCKPS_k\",\"i59TYmf43bc\",\"jjJcKzrwJkY\",\"lrAZ6m6OUxE\",\"nm697Zwq_Xs\",\"XEEyY5Y0pfs\",\"Y3--ghBz1Ro\",\"72Lwsl6yhMw\",\"giDQKidJ2zc\",\"c2lC28kXvrE\",\"xrtwywrxXN8\",\"33QngJaHRi8\",\"D_L8bMd_Bbs\",\"IDDntHCWk88\",\"qIjil4CvckA\",\"BvxPCCOUX7U\",\"24opQhMlyXc\",\"-mlpjBFNITI\",\"VSfypNazlI8\",\"LNkYgzyeiMQ\",\"AQljcaI--6U\",\"QN_esbs4ewE\",\"7_pNniXDBbA\",\"r6TV6lqq3V4\",\"h41QKBJ4f3k\",\"qAYpanFfT7A\",\"bxf_J0OVuTo\",\"yTVDp3YwZlo\",\"NiMHvfEC1VA\",\"e6ElGRAefPI\",\"cw_8S1NMf9E\",\"wiuNcC5eHPU\",\"9aNKmI86ljs\",\"-e3j6fQVG4k\",\"Vzn2BkVB3j0\",\"j8S1Fjaus5I\",\"EqUQYkpOU0E\",\"KzthCNnuaFM\",\"Ik8hlszRkM0\",\"8YDXxm4t0vo\",\"4a25N0JSfn4\",\"o0Lr9ALAtCA\",\"-NpLxk7g0lo\",\"zq64-LPHdpg\",\"mRSP8A2Qa8k\",\"07IxLRtLyco\",\"-lUsdjT4lhU\",\"_ieultKyRW8\",\"RQ5OjiAkO5E\",\"8sUAeZA-ndw\",\"jP23tz3S7w0\",\"m4zVnR4GgcY\",\"51PCbSLb9mQ\",\"otm3SQ_iZW4\",\"M6D_dP1Z9Ks\",\"Jll9f71IttQ\",\"d1e_546cOCg\",\"vHx_NpFxh8A\",\"p_Ahy7_Wb8U\",\"0bCzDPqJqKQ\",\"6bPr5gkYX80\",\"cIN14UmC-yw\",\"l6fFV2Jm630\",\"0EiJ3xcyaaQ\",\"NjTJfah164I\",\"oBAqwWI0s1U\",\"1B7pcwt4nsU\",\"YsKJaRelNxs\",\"CiDtbebJPKA\",\"Xz64Yhw0L8Y\",\"0e8HrBvxqWI\",\"56hvoKldUvk\",\"A-JDxriomxg\",\"3eCSCJQmJ6I\",\"SvGTNGH9i5s\",\"H7nBAHGr76k\",\"cDs2eryW9kU\",\"LDUxBNjXxIo\",\"B1ODLZBdhFE\",\"faD3OcYGcLE\",\"q0Av201iESE\",\"5BMTBvGsoJA\",\"aJYwWuJMuCs\",\"ShlDlb2ejpQ\",\"gA3nKW0JsM8\",\"oT6DBSzzyz8\",\"lvtWDxltxeY\",\"1kMK-6oHwEY\",\"PNdrlePrmRk\",\"f35-DkMRF-c\",\"C-x1OFh8p8U\",\"8DftpJxMZkQ\",\"oBqZ1RSAhZk\",\"01VXL2_DTFQ\",\"3pbOjB3mm-U\",\"m37nJzZ5QZw\",\"Mgyx8sxA5eY\",\"Z2ZvuCNjcxA\",\"e4_qrMybt4E\",\"nQt1SmXP6_0\",\"hIyI2Idv8xE\",\"LlW_11B9qq4\",\"4h3BH8FkgMs\",\"maom06fW5Ic\",\"zzW4P_-dNSc\",\"eel_UB2q1-0\",\"fw9dTuKIUa8\",\"NakJnS0kuHM\",\"Pt9vWyHPd08\",\"m6jOPLp3WfU\",\"BlY4i-mBu6g\",\"KvGhbW-4Cmk\",\"VMUDeL7dLj8\",\"AlaDMktBLKc\",\"J3w9tFGhlEQ\",\"guSXN493c04\",\"bSIYGN_OJ4Q\",\"tTbXx-Awhyw\",\"oXOLTYrqI5g\",\"_zJRw5EQXq0\",\"bqfcFvYm7JQ\",\"xbrFuxTEZ9w\",\"JhH1waXoHy8\",\"_o2cr1BP-sk\",\"OfSSkxxMq6k\",\"zjo89J1x-GA\",\"6ivbITBNz_g\",\"C84AIhCsANM\",\"cOjgfgoqH0I\",\"dMqt8bjBmU8\",\"q7y2_XRqmLM\",\"qW5_iu6Houk\",\"BPQhiusuaGs\",\"ASGtEL3aVEM\",\"g3N_VS-dorE\",\"BGprZfgq0bA\",\"daIeDh_fBjg\",\"3GU_3cFptt4\",\"S4-VSrlReOQ\",\"itaiItdf2uk\",\"5CHPCiYus_s\",\"B07uIJex86Q\",\"QwsCBMd5nLY\",\"iEiJansjdoc\",\"ku3kTWTviYk\",\"Xxsu5AwnIm4\",\"Q0o8H7oDHB0\",\"1lHXfGAlp58\",\"rboU5yzfQDE\",\"VSppIKuLeic\",\"Q8CpvG_cl-Q\",\"jh4olkWdtOE\",\"CsGdDW1l6-Y\",\"FlAK_U4df_s\",\"j8wmpHQD3XY\",\"fAtNEkWnEb0\",\"WPssOk3uQ58\",\"zjiPU-35eUY\",\"lIvzcncvepc\",\"65ZnvyqNssk\",\"F35EVQYNlqs\",\"3EeAZ8bzQwM\",\"P8P1XTtltao\",\"K7fxYKcwnHY\",\"uHt78n7Fdyk\",\"GrE1nQsbtDc\",\"SyZLxnFNNDw\",\"JWtBr9V8KJU\",\"9uO2-qH6P9c\",\"CK8IwnLxxbI\",\"IcXm3u5NHHU\",\"Jg0iazfhsoY\",\"pdw_XKbgpeg\",\"aAKzqbGsCx0\",\"CIQlzM2oEqI\",\"1zsmMWaQSGM\",\"q_mzjNHaOCw\",\"LjU7HnYdkME\",\"sVTtuP3yDXU\",\"hQ2Mq2IKL4w\",\"es5dlOfNSL8\",\"t04zq9R3_0w\",\"i2YnRRF5IjI\",\"quTMhfcgjF0\",\"K_5hcBQSrHg\",\"YuM4O0EU7F8\",\"cza8XHZzFIo\",\"ke5TOxeEL8Q\",\"r12wf_jM390\",\"BqDgKc2UcaU\",\"Qo9Llts1qBQ\",\"erOt5Zhp1go\",\"t29vOoXpeRU\",\"4vHd78qysck\",\"seZJWJ4UDy4\",\"xWZe_6qRGAU\",\"rRctiUI8pmE\",\"eChXOTD_qCE\",\"SSQdugNM-0M\",\"DNdC9hlW65c\"];

	const self = await sb.User.get(\"supibot\");
	const sr = sb.Command.get(\"sr\");
	const link = \"https://youtu.be/\" + sb.Utils.randArray(links);

	const result = await sr.execute({ user: self, channel: channelData, platform: sb.Platform.get(1) }, link);
	await channelData.send(\"Silence prevention! \" + result.reply);
})',
		'Bot',
		1
	)