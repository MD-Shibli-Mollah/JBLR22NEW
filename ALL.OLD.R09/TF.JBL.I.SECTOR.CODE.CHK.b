SUBROUTINE TF.JBL.I.SECTOR.CODE.CHK
*-----------------------------------------------------------------------------
*Subroutine Description: SECTOR CODE AND JBL CODE validation
*Subroutine Type:
*Attached To    : ACTIVITY API (JBL.TF.AC.FCY.API-19990601 , JBL.TF.AC.LCY.API-19990601 , JBL.TF.AC.FCY.API-19990601 , JBL.TF.FCACTAKA.API-19990601)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 02/03/2020 -                            retrofite   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING AA.Framework
    $USING AA.Account
    $USING AA.Customer
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    Y.NULL = ''
    
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.BB.SECTOR',Y.BB.SECTOR.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.AC.JBL.SCODE',Y.JBL.SCODE.POS)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.ARR.ID = AA.Framework.getC_aalocarrid()
    
    PROP.CLASS = 'ACCOUNT'
    AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
    AC.R.REC = RAISE(RETURN.VALUES)
    Y.TEMP.DATA = AC.R.REC<AA.Account.Account.AcLocalRef>
    Y.BB.SECTOR = Y.TEMP.DATA<1,Y.BB.SECTOR.POS>
    Y.JBL.SEC.CODE = Y.TEMP.DATA<1,Y.JBL.SCODE.POS>
    
    IF Y.BB.SECTOR EQ 902401 THEN
        IF Y.JBL.SEC.CODE NE 702489 THEN
            IF Y.JBL.SEC.CODE NE 702490 THEN
                IF Y.JBL.SEC.CODE NE 700000 THEN
                    EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
                    EB.SystemTables.setAv(Y.JBL.SCODE.POS)
                    EB.SystemTables.setEtext("JBL Sector Code must be 702489 or 702490 or NOT APPLICABLE")
                    EB.ErrorProcessing.StoreEndError()
                END
            END
        END
    END
    IF Y.BB.SECTOR EQ 902402 THEN
        IF Y.JBL.SEC.CODE NE 702491 THEN
            EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
            EB.SystemTables.setAv(Y.JBL.SCODE.POS)
            EB.SystemTables.setEtext("JBL Sector Code must be 702491 or NOT APPLICABLE")
            EB.ErrorProcessing.StoreEndError()
        END
    END
    IF Y.BB.SECTOR EQ 902120 THEN
        IF Y.JBL.SEC.CODE NE 702164 THEN
            IF Y.JBL.SEC.CODE NE 700000 THEN
                EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
                EB.SystemTables.setAv(Y.JBL.SCODE.POS)
                EB.SystemTables.setEtext("JBL Sector Code must be 702164 or NOT APPLICABLE")
                EB.ErrorProcessing.StoreEndError()
            END
        END
    END
    IF Y.BB.SECTOR EQ 902406 THEN
        IF Y.JBL.SEC.CODE NE 702492 THEN
            IF Y.JBL.SEC.CODE NE 702493 THEN
                IF Y.JBL.SEC.CODE NE 700000 THEN
                    EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
                    EB.SystemTables.setAv(Y.JBL.SCODE.POS)
                    EB.SystemTables.setEtext("JBL Sector Code must be 702492 or 702493 or NOT APPLICABLE")
                    EB.ErrorProcessing.StoreEndError()
                END
            END
        END
    END
    IF Y.BB.SECTOR EQ 902430 THEN
        IF Y.JBL.SEC.CODE NE 702494 THEN
            IF Y.JBL.SEC.CODE NE 700000 THEN
                EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
                EB.SystemTables.setAv(Y.JBL.SCODE.POS)
                EB.SystemTables.setEtext("JBL Sector Code must be 702494 or NOT APPLICABLE")
                EB.ErrorProcessing.StoreEndError()
            END
        END
    END
    IF Y.BB.SECTOR EQ 902155 THEN
        IF Y.JBL.SEC.CODE NE 702165 THEN
            IF Y.JBL.SEC.CODE NE 700000 THEN
                EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
                EB.SystemTables.setAv(Y.JBL.SCODE.POS)
                EB.SystemTables.setEtext("JBL Sector Code must be 702165 or NOT APPLICABLE")
                EB.ErrorProcessing.StoreEndError()
            END
        END
    END
    IF Y.BB.SECTOR NE 902120 THEN
        IF Y.BB.SECTOR NE 902155 THEN
            IF Y.BB.SECTOR NE 902401 THEN
                IF Y.BB.SECTOR NE 902402 THEN
                    IF Y.BB.SECTOR NE 902406 THEN
                        IF Y.BB.SECTOR NE 902430 THEN
                            IF Y.JBL.SEC.CODE NE '' THEN
                                EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
                                EB.SystemTables.setAv(Y.JBL.SCODE.POS)
                                EB.SystemTables.setEtext("JBL Sector Code Should be Null")
                                EB.ErrorProcessing.StoreEndError()
                            END
                        END
                    END
                END
            END
        END
    END
        
RETURN
*** </region>


END
