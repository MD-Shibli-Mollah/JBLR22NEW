* Version 2 02/06/00  GLOBUS Release No. G11.0.00 29/06/00
SUBROUTINE BD.INT.NOTICE.INFO.VALIDATE
*-----------------------------------------------------------------------------
    !** Template FOR validation routines
*Developer Info:
*    Date         : 30/03/2022
*    Description  : validation routine for the BD.INT.ACCOUNT.VIOINFO template
*    Developed By : Md. Tajul Islam
*    Designation  : Software Engineer
*    Email        : tajul.ntl@nazihargroup.com
*ackage infra.eb
*!
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*-----------------------------------------------------------------------------
* 07/06/06 - BG_100011433
*            Creation
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Main section>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.INT.VIOLATION.PARAM
    $INSERT I_F.BD.INT.NOTICE.INFO
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING EB.ErrorProcessing
 
    GOSUB READPARAM
    GOSUB VALIDATE
RETURN
*** </region>
*-----------------------------------------------------------------------------
VALIDATE:
    Y.TODAY=EB.SystemTables.getToday()
    Y.DATE=EB.SystemTables.getRNew(INT.VIO.DATE)
   
    Y.DATE.COUNT=DCOUNT(Y.DATE,VM)
    IF Y.DATE.COUNT EQ 0 THEN
        Y.DATE.COUNT=1
    END
*
    FOR I=1 TO Y.DATE.COUNT
        Y.DAYS='C'
        IF Y.DATE<1,I> EQ '' THEN
            EB.SystemTables.setEtext('enter a valid date')
            EB.ErrorProcessing.StoreEndError()
        END
        EB.API.Cdd("",Y.TODAY,Y.DATE<1,I>, Y.DAYS)
        IF Y.DAYS GT Y.NOTICE.PERIOD THEN
            EB.SystemTables.setAf(Y.DATE<1,I>)
            Y.E.TEXT='Date must be within ':Y.NOTICE.PERIOD:' Calender Days from Today'
            EB.SystemTables.setEtext(Y.E.TEXT)
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.DATE<1,I> LT Y.TODAY THEN
            EB.SystemTables.setAf(Y.DATE<1,I>)
            Y.E.TEXT='Please Delete Expired notice Record'
            EB.SystemTables.setEtext(Y.E.TEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    NEXT I
    Y.START.DATES=EB.SystemTables.getRNew(INT.VIO.FROM.DATE)
    Y.END.DATES=EB.SystemTables.getRNew(INT.VIO.END.DATE)
    Y.DATES.LEN=DCOUNT(Y.START.DATES,VM)
    FOR I=1 TO Y.DATES.LEN
        EB.API.Cdd("",Y.START.DATES<1,I>, Y.END.DATES<1,I>, Y.DAYS)
        IF Y.DAYS GT 7 THEN
*EB.SystemTables.setAf(INT.VIO.FROM.DATE,1,I)
            Y.E.TEXT='Maximum Date difference can be 7 calender days'
            EB.SystemTables.setEtext(Y.E.TEXT)
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.DATES.LEN GT 1 AND Y.END.DATES<1,I-1> NE '' THEN
            IF Y.START.DATES<1,I> LE Y.END.DATES<1,I-1> THEN
                Y.E.TEXT='Date overlapped'
                EB.SystemTables.setEtext(Y.E.TEXT)
                EB.ErrorProcessing.StoreEndError()
            END
        END
    NEXT I
RETURN
*-----------------------------------------------------------------------------
READPARAM:
***
    Y.PARAM.ID='SYSTEM'
    FN.BD.INT.VIOLATION.PARAM='F.BD.INT.VIOLATION.PARAM'
    F.BD.INT.VIOLATION.PARAM=''
    EB.DataAccess.Opf(FN.BD.INT.VIOLATION.PARAM, F.BD.INT.VIOLATION.PARAM)
    EB.DataAccess.FRead(FN.BD.INT.VIOLATION.PARAM, Y.PARAM.ID,R.PARAM.REC, F.BD.INT.VIOLATION.PARAM, Er)
    Y.NOTICE.PERIOD=R.PARAM.REC<INT.VIO.PARAM.NOTICE.PERIOD>
    Y.NOTICE.VALIDITY=R.PARAM.REC<INT.VIO.PARAM.NOTICE.>
*VALIDITY
RETURN
END
