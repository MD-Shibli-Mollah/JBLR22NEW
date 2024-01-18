SUBROUTINE TF.JBL.V.LD.FLD.VAL.CK
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*Attached: Activity.Api - JBL.TF.IDBP.API, JBL.TF.IBD.API, JBL.TF.FDBP.API
*-----------------------------------------------------------------------------
* 11/17/2020 -                            Retrofit   - MAHMUDUR RAHMAN UDOY,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
*Description: this routine check for AD Branch DR Pur Reference Number Existence.
*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.LC.AD.CODE
    
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.SystemTables
    $USING AA.Framework
    $USING AA.Account
    $USING EB.Updates
    $USING EB.ErrorProcessing
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
INITIALISE:
    FN.ARR = 'F.AA.ARRANGEMENT'
    F.ARR = ''
      
    FN.AD.CODE = 'F.BD.LC.AD.CODE'
    F.AD.CODE  = ''
    
    Y.APP="AA.ARR.ACCOUNT"
    Y.FLDS="LINKED.TFDR.REF":VM:"LT.TF.IMP.PADID"
    Y.POS= ''
 
    Y.COMPANY = EB.SystemTables.getIdCompany()
    
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLDS,Y.POS)
    Y.TFDR.REF.POS = Y.POS<1,1>
*    Y.LTR.PAD.ID.POS = Y.POS<1,2>

    
    
RETURN
   
OPENFILE:
    
    EB.DataAccess.Opf(FN.ARR, F.ARR)
    EB.DataAccess.Opf(FN.AD.CODE,F.AD.CODE)
   
RETURN
   
PROCESS:

    Y.AC.LOC.REF = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
    Y.TFDR.REF = Y.AC.LOC.REF<1, Y.TFDR.REF.POS>
    EB.DataAccess.FRead(FN.AD.CODE, Y.COMPANY, REC.AD.CODE, F.AD.CODE, ERR.REC)
    IF REC.AD.CODE THEN
        Y.AD.CODE.NUM = REC.AD.CODE<AD.CODE.AD.CODE>
        IF Y.AD.CODE.NUM NE '' THEN
            Y.ARR.ID = AA.Framework.getC_aalocarrid()
            EB.DataAccess.FRead(FN.ARR, Y.ARR.ID, ARR.REC, F.ARR, ARR.ERR)
            IF ARR.REC THEN
                Y.PROD.GP = ARR.REC<AA.Framework.Arrangement.ArrProductGroup>
                IF Y.TFDR.REF EQ '' THEN
                    IF Y.PROD.GP EQ 'JBL.FDBP.LN' OR Y.PROD.GP EQ 'JBL.IDBP.LN' THEN
                        EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
                        EB.SystemTables.setAv(Y.TFDR.REF.POS)
                        EB.SystemTables.setEtext("DR Pur Reference Number input Missing")
                        EB.ErrorProcessing.StoreEndError()
                    END
                END
            END
        END
    END
RETURN
END
