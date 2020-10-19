public class PositionsAutoCloseOld implements Schedulable{
    public static final String EVERY_DAY = '0 0 0 * * ?';
    public static final String CLOSE_OLD_POSITIONS = 'Close old positions';

    public void execute(SchedulableContext SC) {
        PositionsAutoCloseOldHandler handler = new PositionsAutoCloseOldHandler();
        handler.closeOldPositions();
    }
}