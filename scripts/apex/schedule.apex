String jobId = System.schedule(PositionsAutoCloseOld.CLOSE_OLD_POSITIONS,
    PositionsAutoCloseOld.EVERY_DAY, new PositionsAutoCloseOld());

