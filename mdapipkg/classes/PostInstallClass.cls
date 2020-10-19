global class PostInstallClass implements InstallHandler {
    global void onInstall(InstallContext context) {

        String jobId = System.schedule(PositionsAutoCloseOld.CLOSE_OLD_POSITIONS,
            PositionsAutoCloseOld.EVERY_DAY, new PositionsAutoCloseOld());
    }
}