SUBROUTINE TF.JBL.I.BOE.OVERDUE.CHK
*-----------------------------------------------------------------------------
*Subroutine Description: Check whether any overdue Bill of Entry exist or not against applicant customer ID during opening of Import Sight/Usance Letter of Credit
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT VERSION (LETTER.OF.CREDIT,IMPSIGHT, LETTER.OF.CREDIT,IMPUSANCE)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 17/12/2019 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.BILL.ENTRY
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING LC.Contract
    $USING LC.Config
    $USING EB.API
    $USING EB.LocalReferences
    $USING ST.Customer
    $USING EB.OverrideProcessing
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------
 
*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC.APPLICANT = "F.LC.APPLICANT"
    F.LC.APPLICANT = ""
    FN.LC = "F.LETTER.OF.CREDIT"
    F.LC = ""
    FN.DR = "F.DRAWINGS"
    F.DR = ""
    FN.LC.TYPES = "F.LC.TYPES"
    F.LC.TYPES = ""
    FN.JBL.BILL.ENTRY = "F.JBL.BILL.ENTRY"
    F.JBL.BILL.ENTRY = ""
    
    EB.LocalReferences.GetLocRef("LC.TYPES", "LT.LCTP.LOC.FRG", Y.LC.TYPES.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS", "LT.TF.MAT.DATE", Y.MAT.DATE.POS)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC.APPLICANT,F.LC.APPLICANT)
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.DR,F.DR)
    EB.DataAccess.Opf(FN.LC.TYPES,F.LC.TYPES)
    EB.DataAccess.Opf(FN.JBL.BILL.ENTRY,F.JBL.BILL.ENTRY)
RETURN
*** </region>
 
*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.APP.CUS.ID = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcApplicantCustno)
    EB.DataAccess.FRead(FN.LC.APPLICANT, Y.APP.CUS.ID, R.LC.APPLICANT, F.LC.APPLICANT, Y.LC.APPLICANT.ERR)
    IF R.LC.APPLICANT THEN
        LOOP
            REMOVE LC.TYPE.ID FROM R.LC.APPLICANT SETTING V.STATUS
            EB.DataAccess.FRead(FN.LC, LC.TYPE.ID, R.LC, F.LC, Y.LC.ERR)
            IF R.LC THEN
                LC.TYPES = R.LC<LC.Contract.LetterOfCredit.TfLcLcType>
                EB.DataAccess.FRead(FN.LC.TYPES, LC.TYPES, R.LC.TYPES, F.LC.TYPES, Y.LC.TYPES.ERR)
                IF R.LC.TYPES THEN
                    Y.LOC.FRG = R.LC.TYPES<LC.Config.Types.TypLocalRef, Y.LC.TYPES.POS>
                    IF Y.LOC.FRG EQ "FOREIGN" THEN
                        Y.NEXT.DRAWINGS = R.LC<LC.Contract.LetterOfCredit.TfLcNextDrawing>
                        Y.COUNT = 1
                        LOOP
                            IF Y.COUNT EQ Y.NEXT.DRAWINGS THEN BREAK
                            
                            R.JBL.BILL.ENTRY = ""
                            Y.COUNT = FMT(Y.COUNT, "R%2")
                            Y.DR.ID = LC.TYPE.ID:Y.COUNT
                            EB.DataAccess.FRead(FN.JBL.BILL.ENTRY, Y.DR.ID, R.JBL.BILL.ENTRY, F.JBL.BILL.ENTRY, Y.JBL.BILL.ENTRY.ERR)
                            EB.DataAccess.FRead(FN.DR, Y.DR.ID, R.DR, F.DR, Y.DR.ERR)
                            
                            Y.BILL.OF.ENTRY.REC = R.JBL.BILL.ENTRY<BILL.ENTRY.BILL.OF.ENTRY.REC>
                            IF Y.BILL.OF.ENTRY.REC NE 'YES' THEN
                                IF R.JBL.BILL.ENTRY AND R.DR THEN
                                    Y.DATE.TODAY = EB.SystemTables.getToday()
                                    Y.BOE.PAY.DATE = R.JBL.BILL.ENTRY<BILL.ENTRY.DATE.OF.PAYMENT>
                                    Y.DR.TYPE = R.DR<LC.Contract.Drawings.TfDrDrawingType>
                                  
******************** ADDITIONAL ********************
                                    Y.DR.MAT.DATE = R.DR<LC.Contract.Drawings.TfDrLocalRef, Y.MAT.DATE.POS>
                                    IF Y.DR.MAT.DATE NE "" AND Y.DATE.TODAY NE "" THEN
                                        IF Y.DR.MAT.DATE LT Y.DATE.TODAY AND Y.DR.TYPE EQ "AC" THEN
                                            EB.SystemTables.setText("Overdue Bill Exist in ":Y.DR.ID)
                                            EB.OverrideProcessing.StoreOverride("")
                                        END
                                    END
                                
********************END ADDITIONAL ********************
                                    IF Y.BOE.PAY.DATE THEN
                                        Y.DATE.DIFF = "C"
                                        EB.API.Cdd("",Y.BOE.PAY.DATE, Y.DATE.TODAY, Y.DATE.DIFF)
                                        IF ABS(Y.DATE.DIFF) GT "120" AND Y.DR.TYPE EQ "AC" THEN
                                            EB.SystemTables.setText("Bill of Entry Overdue Exist in ":Y.DR.ID)
                                            EB.OverrideProcessing.StoreOverride("")
                                        END
                                    END
                                END
                            END
                            
                            
                            
                            Y.COUNT++
                        REPEAT
                    END
                END
            END
            
            IF V.STATUS EQ 0 THEN BREAK ;* check the status at the end of the loop
        REPEAT
    END

RETURN
*** </region>


END
