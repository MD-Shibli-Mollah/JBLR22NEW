SUBROUTINE TF.JBL.I.PI.OVERRIDE
*-----------------------------------------------------------------------------
*Subroutine Description: amount not match override
*Subroutine Type:
*Attached To    : JBL.PI,JBL.INPUT
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 14/06/2020 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.PI
    
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''
    FN.PI = 'F.JBL.PI'
    F.PI = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.PI,F.PI)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.PI.ID = EB.SystemTables.getIdNew()
    
    EB.DataAccess.FRead(FN.LC, Y.PI.ID, REC.LC, F.LC, ERR.LC)
    IF REC.LC THEN
        Y.LC.AMOUNT = REC.LC<LC.Contract.LetterOfCredit.TfLcLcAmount>
    END
    Y.PI.COMDT.VOL.VM = EB.SystemTables.getRNew(PI.COMDT.VOL)
    Y.PI.UNIT.PRIC.VM = EB.SystemTables.getRNew(PI.UNIT.PRIC)
    Y.PI.AMT = EB.SystemTables.getRNew(PI.PI.AMT)
    
*    CONVERT SM TO VM IN Y.PI.COMDT.VOL.LIST
*    CONVERT SM TO VM IN Y.PI.UNIT.PRIC.LIST
*
    Y.VM.COUNT = DCOUNT(Y.PI.COMDT.VOL.VM,VM)
    Y.PI.AMOUNT.TOTAL = "0"
    
    FOR I=1 TO Y.VM.COUNT
        Y.PI.COMDT.VOL.SM = FIELD(Y.PI.COMDT.VOL.VM,VM,I)
        Y.PI.UNIT.PRIC.SM = FIELD(Y.PI.UNIT.PRIC.VM,VM,I)
        
        Y.SM.COUNT = DCOUNT(Y.PI.COMDT.VOL.SM,SM)
        FOR J=1 TO Y.SM.COUNT
            Y.PI.COMDT.VOL = FIELD(Y.PI.COMDT.VOL.SM,SM,J)
            Y.PI.UNIT.PRIC = FIELD(Y.PI.UNIT.PRIC.SM,SM,J)
            IF Y.PI.COMDT.VOL NE "" AND Y.PI.UNIT.PRIC NE "" THEN
		        Y.PI.AMOUNT = Y.PI.COMDT.VOL * Y.PI.UNIT.PRIC
	            Y.PI.AMT<1,I,J> = Y.PI.AMOUNT
		        Y.PI.AMOUNT.TOTAL += Y.PI.AMOUNT
            END
        NEXT J
    NEXT I
    
    EB.SystemTables.setRNew(PI.PI.AMT, Y.PI.AMT)
*    EB.DataAccess.FRead(FN.PI, Y.PI.ID, REC.PI, F.PI, ERR.PI)
*    Y.OVERRIDE = REC.PI<PI.OVERRIDE>
*    Y.OVR.COUNT = DCOUNT(Y.OVERRIDE,VM)
    
    IF Y.LC.AMOUNT NE Y.PI.AMOUNT.TOTAL THEN
*        EB.SystemTables.setText("LC amount and PI total amout are not same")
*        EB.OverrideProcessing.StoreOverride(Y.OVR.COUNT+1)
        Y.OVERRIDES = EB.SystemTables.getRNew(PI.OVERRIDE)
        OVERRIDE.NO = DCOUNT(Y.OVERRIDES,VM)
        IF Y.OVERRIDES<1,OVERRIDE.NO> EQ "LC amount and PI total amout are not same" THEN RETURN
        OVERRIDE.NO += 1
        EB.SystemTables.setText("LC amount and PI total amout are not same")
        EB.OverrideProcessing.StoreOverride(OVERRIDE.NO)
    END
RETURN
*** </region>

END
