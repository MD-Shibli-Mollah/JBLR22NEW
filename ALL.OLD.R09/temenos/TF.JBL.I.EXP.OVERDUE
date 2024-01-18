SUBROUTINE TF.JBL.I.EXP.OVERDUE
*-----------------------------------------------------------------------------
*Subroutine Description: Export LC overdue check
*Subroutine Type:
*Attached To    : DRAWINGS VERSION (DRAWINGS,F.EXPCOLL)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/02/2020 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.EXP
*
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Foundation
    $USING EB.API
    $USING EB.OverrideProcessing
*-----------------------------------------------------------------------------
*
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.DR = 'F.DRAWINGS'
    F.DR = ''
    FN.JBL.EXP = 'F.JBL.EXP'
    F.JBL.EXP = ''
RETURN
**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.DR, F.DR)
    EB.DataAccess.Opf(FN.JBL.EXP, F.JBL.EXP)
RETURN
********
PROCESS:
********
    EB.Foundation.MapLocalFields("DRAWINGS", "LT.TF.APL.CUSNO", Y.CUS.POS)
    Y.CUS.ID = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1, Y.CUS.POS>
    
    EB.DataAccess.FRead(FN.JBL.EXP, Y.CUS.ID, R.JBL.EXP, F.JBL.EXP, Y.JBL.EXP.ERR)
    IF R.JBL.EXP THEN
        Y.STOCK.CNT=DCOUNT(R.JBL.EXP<EXP.DRAWINGS.ID>,VM)
        Y.COUNT = 0
        LOOP
            Y.COUNT++
            Y.DR.ID = R.JBL.EXP<EXP.DRAWINGS.ID, Y.COUNT>
            Y.EXP.DATE = R.JBL.EXP<EXP.EXPORT.DATE, Y.COUNT>
            Y.DR.TYPE = R.JBL.EXP<EXP.DRAWINGS.TYPE, Y.COUNT>
            
            IF Y.DR.TYPE EQ "CO" THEN
                Y.TODAY = EB.SystemTables.getToday()
                Y.DATE.DIFF = "C"
                EB.API.Cdd("",Y.EXP.DATE, Y.TODAY, Y.DATE.DIFF)
                IF Y.DATE.DIFF GT "120" THEN
                    EB.SystemTables.setText("Export Date Overdue Exist in Drawing Id: ":Y.DR.ID)
                    EB.OverrideProcessing.StoreOverride("")
                END
            END
            
            IF Y.COUNT EQ Y.STOCK.CNT THEN BREAK ;* check the status at the end of the loop
        REPEAT
    END
          
RETURN

END