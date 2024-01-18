SUBROUTINE TF.JBL.V.VAL.LC.HS.CODE
*-----------------------------------------------------------------------------
*Subroutine Description: HS Code Validation
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.IMPSIGH | LETTER.OF.CREDIT,JBL.BTBUSANCE
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 22/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.Display
    $USING LC.Contract
    $USING ST.Config
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
     
    $INSERT I_F.BD.HS.CODE.LIST
    $INSERT I_F.JBL.PI
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getMessage() EQ "VAL" THEN RETURN
    IF EB.SystemTables.getComi() EQ "" THEN RETURN
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.HS.CODE.LIST = 'F.BD.HS.CODE.LIST'
    F.HS.CODE.LIST = ''
    
    Y.APP = 'LETTER.OF.CREDIT'
    Y.FLD = 'LT.TF.COMMO.COD'
    Y.POS = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.HS.CODE.LIST,FV.HS.CODE.LIST)
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLD,Y.POS)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.BB.COMMODITY.POS = Y.POS<1,1>
    Y.HS.CODE = EB.SystemTables.getComi()
    EB.DataAccess.FRead(FN.HS.CODE.LIST, Y.HS.CODE, R.HS.CODE, F.HS.CODE.LIST, HS.ERR)

    IF R.HS.CODE THEN
        Y.DES = R.HS.CODE<HS.CO.DESCRIPTION>
        Y.STATUS = R.HS.CODE<HS.CO.STATUS>
        Y.CLAUSE = R.HS.CODE<HS.CO.SPCL.PRMSN.CLAUSE>
        IF Y.STATUS EQ "RESTRICTED" THEN
            EB.SystemTables.setText("HS CODE ":Y.HS.CODE:" RESTRICTED, ":Y.CLAUSE)
            EB.OverrideProcessing.StoreOverride("")
        END
        IF Y.STATUS EQ "PROHIBITED" THEN
            EB.SystemTables.setEtext("HS CODE PROHIBITED")
            EB.ErrorProcessing.StoreEndError()
        END
     
        
        Y.DESC.GOODS = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcDescGoods)
        CHANGE ' ' TO VM IN Y.DESC.GOODS
        IF Y.DESC.GOODS THEN
            FINDSTR EB.SystemTables.getComi() IN Y.DESC.GOODS SETTING POS ELSE
                EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcDescGoods, EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcDescGoods):" ":EB.SystemTables.getComi())
            END
        END ELSE
            EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcDescGoods, EB.SystemTables.getComi())
        END
*        EB.SystemTables.setComiEnri(R.HS.CODE<BD.Description>)
******************** BLOCKED THE PART AT DATE 20210627 *************************
*        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
*        Y.TEMP<1,Y.BB.COMMODITY.POS> = Y.HS.CODE
*        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
******************************************************************
    END ELSE
        EB.SystemTables.setEtext('Invalid HS Code')
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
RETURN
*** </region>

END
