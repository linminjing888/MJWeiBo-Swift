-- 创建微博数据 --

CREATE TABLE IF NOT EXISTS "T_Status" (
"statusId" INTEGER NOT NULL,
"UserId" INTEGER NOT NULL,
"status" TEXT,
"createtime" TEXT DEFAULT (datetime('now', 'localtime')),
PRIMARY KEY("statusId","UserId")
)
