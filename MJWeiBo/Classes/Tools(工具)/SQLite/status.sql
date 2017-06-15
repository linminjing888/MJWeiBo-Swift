-- 创建微博数据 --
CREATE TABLE "T_Status" (
    "statusId" INTEGER NOT NULL,
    "UserId" INTEGER NOT NULL,
    "status" TEXT,
    PRIMARY KEY("statusId","UserId")
);
