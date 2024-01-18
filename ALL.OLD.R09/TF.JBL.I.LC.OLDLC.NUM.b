* @ValidationCode : MjotMjIzMzQ4NDAzOkNwMTI1MjoxNjMyODEwNTc1NDkxOnVzZXI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMTlfU1AzNy4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Sep 2021 12:29:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R19_SP37.0
SUBROUTINE TF.JBL.I.LC.OLDLC.NUM
*-----------------------------------------------------------------------------
*Subroutine Description: OLD LC number generate (BB LC number)
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.IMPSIGH)
*Attached As    : INPUT ROUTINE
*------------------------------------------------------------------- ----------
* Modification History :
* 23/10/2019 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING LC.Config
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Display
    $USING EB.Updates
    $USING EB.LocalReferences
    $INCLUDE I_F.BD.LC.SERIAL.NUMBER
    $INCLUDE I_F.BD.LC.AD.CODE
    
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getMessage() EQ "INP" THEN RETURN
    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOldLcNumber) THEN RETURN
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*GOSUB LC.CLASSIFICATION
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC= ''
    
    FN.LC.MN = 'F.MNEMONIC.LETTER'
    F.LC.MN = ''
    
    FN.LC.SL.NO = 'F.BD.LC.SERIAL.NUMBER'
    F.LC.SL.NO = ''
    
    FN.AD.CODE = 'F.BD.LC.AD.CODE'
    F.AD.CODE = ''
    
    FN.LC.TYPE = 'F.LC.TYPES'
    F.LC.TYPE = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.LC.MN,F.LC.MN)
    EB.DataAccess.Opf(FN.LC.SL.NO,F.LC.SL.NO)
    EB.DataAccess.Opf(FN.AD.CODE,F.AD.CODE)
    EB.DataAccess.Opf(FN.LC.TYPE,F.LC.TYPE)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    EB.DataAccess.FRead(FN.AD.CODE,EB.SystemTables.getIdCompany(),R.AD.CODE,F.AD.CODE,AD.ERR)
    IF R.AD.CODE THEN
        Y.BRANCH.CODE = R.AD.CODE<AD.CODE.AD.CODE>
        IF Y.BRANCH.CODE ELSE
            EB.SystemTables.setEtext('Branch Code Missing for LC Type')
            EB.ErrorProcessing.StoreEndError()
        END
    END ELSE
        EB.SystemTables.setEtext('Company Not Defined in DEALERS Code')
        EB.ErrorProcessing.StoreEndError()
    END


    Y.LC.TYPE= EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcType)

    EB.DataAccess.FRead(FN.LC.TYPE,Y.LC.TYPE,R.LC.TYPE,F.LC.TYPE,LC.ERR)
    IF R.LC.TYPE THEN
        EB.LocalReferences.GetLocRef("LC.TYPES","LT.LCTP.LC.CODE",Y.LC.CODE.POS)
        Y.LC.CODE = FMT(R.LC.TYPE<LC.Config.Types.TypLocalRef,Y.LC.CODE.POS>,'R%2')
        LC.DESC = R.LC.TYPE<LC.Config.Types.TypDescription>
    END ELSE
        EB.SystemTables.setEtext('LC Type Missing')
        EB.ErrorProcessing.StoreEndError()
    END
 
    IF Y.LC.CODE ELSE
        EB.SystemTables.setEtext('LC Code Not Defined in LC Type')
        EB.ErrorProcessing.StoreEndError()
    END

    IF INDEX(LC.DESC,"Inl",1) AND INDEX(LC.DESC,"LCY",1) THEN
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency, EB.SystemTables.getLccy())
    END

    Y.YR.LC = EB.SystemTables.getToday()[3,2]
    LC.SL.NO.ID = EB.SystemTables.getToday()[1,4]
    EB.DataAccess.FRead(FN.LC.SL.NO,LC.SL.NO.ID,R.LC.SL.NO,F.LC.SL.NO,LC.SL.ERR)
    IF R.LC.SL.NO THEN
        LOCATE Y.BRANCH.CODE IN R.LC.SL.NO<LC.SLNO.BRANCH.CODE,1> SETTING Y.POS THEN
            LOCATE Y.LC.CODE IN R.LC.SL.NO<LC.SLNO.LC.TYPE.CODE,Y.POS,1> SETTING Y.POS.TYP THEN
                IF R.LC.SL.NO<LC.SLNO.LC.SEQ.NO,Y.POS,Y.POS.TYP> EQ '' THEN
                    Y.SEQ.NO = '0001'
                END ELSE
                    Y.SEQ.NO = R.LC.SL.NO<LC.SLNO.LC.SEQ.NO,Y.POS,Y.POS.TYP> + 1
                END
                Y.SEQ.NO = FMT(Y.SEQ.NO,'R%4')
            END ELSE
                Y.SEQ.NO = '0001'
            END
        END ELSE
            Y.SEQ.NO = '0001'
        END
    END ELSE
        Y.SEQ.NO = '0001'
    END
    
    IF Y.LC.CODE EQ '03' OR Y.LC.CODE EQ '04' THEN
        Y.SEQ.NO = FMT(Y.SEQ.NO,'R%5')
    END

    Y.GEN.OLD.LC.NO = Y.BRANCH.CODE:Y.YR.LC:Y.LC.CODE:Y.SEQ.NO
    
    LOOP
        EB.DataAccess.FRead(FN.LC.MN, Y.GEN.OLD.LC.NO, R.LC.MN, F.LC.MN, E.LC.MN)
        IF R.LC.MN EQ "" THEN BREAK
        Y.GEN.OLD.LC.NO = Y.GEN.OLD.LC.NO + 1
    REPEAT
    
    EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcOldLcNumber, Y.GEN.OLD.LC.NO)
RETURN

END
    