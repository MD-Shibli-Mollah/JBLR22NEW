SUBROUTINE TF.JBL.I.BOE.MATCHING
*-----------------------------------------------------------------------------
*Subroutine Description: BOE amount matching check with LC
*Subroutine Type:
*Attached To    : JBL.BILL.ENTRY,RECV version
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 27/04/2020 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $INCLUDE I_F.JBL.BILL.ENTRY
      
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.DR.DOC.AMT = EB.SystemTables.getRNew(BILL.ENTRY.DOC.AMT)
    Y.BOE.AMT = EB.SystemTables.getRNew(BILL.ENTRY.BOE.AMT)
    Y.BILL.OF.ENT = EB.SystemTables.getRNew(BILL.ENTRY.BILL.OF.ENTRY.REC)
    IF Y.DR.DOC.AMT NE "" AND Y.BOE.AMT NE "" THEN
        Y.MATCH.PERC = DROUND((Y.BOE.AMT / Y.DR.DOC.AMT) * 100)
        IF Y.BILL.OF.ENT EQ '' THEN
            IF Y.MATCH.PERC GE '100' THEN
                EB.SystemTables.setRNew(BILL.ENTRY.BILL.OF.ENTRY.REC, 'YES')
            END ELSE
                EB.SystemTables.setRNew(BILL.ENTRY.BILL.OF.ENTRY.REC, 'NO')
            END
        END
        EB.SystemTables.setText("BOE Amount matched ":Y.MATCH.PERC:"%")
        EB.OverrideProcessing.StoreOverride("")
    END
         
RETURN
*** </region>

END
