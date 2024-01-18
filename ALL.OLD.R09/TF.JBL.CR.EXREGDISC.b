SUBROUTINE TF.JBL.CR.EXREGDISC
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type: this routine auto-populate LC information when Drawings are opening.
*Attached To    : DRAWINGS Version (DRAWINGS,JBL.EXREGDISC)
*Attached As    : CHECK ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
*DATE: 07/13/2020                         Create by: MAHMUDUR RAHMAN(UDOY)
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
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
    FN.LC='F.LETTER.OF.CREDIT'
    F.LC = ''

    Y.LC.ID = ''
    Y.DR.ID = ''
    FLD.POS = ''
    APPLICATION.NAMES = 'LETTER.OF.CREDIT':FM:'DRAWINGS'
    LOCAL.FIELDS =  'LT.TF.JOB.NUMBR':VM:'LT.TF.BTB.CNTNO':FM:'LT.TF.JOB.NUMBR':VM:'LT.TF.EXP.LC.NO':VM:'LT.TF.BTB.CNTNO':VM:'LT.TF.APL.CUSNO'
*                           1                    2                     1                    2                   3                    4
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.LC.JOB.POS    = FLD.POS<1,1>
    Y.LC.CNT.NO.POS = FLD.POS<1,2>
    Y.DR.JOB.POS    = FLD.POS<2,1>
    Y.LC.NO.POS     = FLD.POS<2,2>
    Y.CNT.NO.POS    = FLD.POS<2,3>
    Y.CUS.NO.POS    = FLD.POS<2,4>
    
RETURN

OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC,F.LC)
RETURN

PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.DR.ID= EB.SystemTables.getIdNew()
    Y.LC.ID = Y.DR.ID[1,12]
    
    

    IF Y.LC.ID THEN
        
*****************   VALUE GET FROM LC APPLICATION    *********************************
        EB.DataAccess.FRead(FN.LC, Y.LC.ID, LC.REC, F.LC, ERR.REC)
        IF LC.REC THEN
            Y.LC.LOC.FLD = LC.REC<LC.Contract.LetterOfCredit.TfLcLocalRef>
            Y.LC.JOB.NO = Y.LC.LOC.FLD<1,Y.LC.JOB.POS>
            Y.LC.CNT.NO = Y.LC.LOC.FLD<1,Y.LC.CNT.NO.POS>
            Y.BENIF.CUS.NO = LC.REC<LC.Contract.LetterOfCredit.TfLcBeneficiaryCustno>
        END
    
****************VALUE SET TO DR VERSION LOCAL FIELDS.*********************************
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
        Y.TEMP<1,Y.DR.JOB.POS>  = Y.LC.JOB.NO
        Y.TEMP<1,Y.LC.NO.POS>  = Y.LC.ID
        Y.TEMP<1,Y.CNT.NO.POS>  = Y.LC.CNT.NO
        Y.TEMP<1,Y.CUS.NO.POS>  = Y.BENIF.CUS.NO
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
        
    END
RETURN
*** </region>
END
