$PACKAGE BD.SOC
*
* Implementation of BD.SOC.SocGetChgAmt
*
* Y.ACCOUNTNO(IN) :
* Y.COM.CODE(IN) :
* Y.BASE.BALANCE(IN) :
* Y.THRESHOLD.CHG(IN) :
* Y.PARITAL.FLAG(IN) :
* Y.APPLIED.CHG(IN) :
* Y.CHG.AMT(OUT) :
* Y.VAT.AMT(OUT) :
* Y.REL.CHG(OUT) :
* Y.REL.VAT(OUT) :
* Y.DUE.AMT(OUT) :
* Y.DUE.VAT(OUT) :
*
SUBROUTINE BD.SOC.GET.CHGAMT(Y.ACCOUNTNO, Y.COM.CODE, Y.BASE.BALANCE, Y.THRESHOLD.CHG, Y.PARITAL.FLAG, Y.APPLIED.CHG,Y.RESTRICTIONS, Y.CHG.AMT, Y.VAT.AMT, Y.REL.CHG, Y.REL.VAT, Y.DUE.AMT, Y.DUE.VAT)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SOC.PARAM
*
    $USING EB.DataAccess
    $USING CG.ChargeConfig
    $USING AC.AccountOpening
*-----------------------------------------------------------
    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN
*-----------INIT START-------------
INIT:
    FN.COM.TYPE='F.FT.COMMISSION.TYPE'
    F.COM.TYPE=''
    FN.TAX='F.TAX'
    F.TAX=''
RETURN
*-----------INIT END-------------
*-----------OPENFILE START-------------
OPENFILE:
    EB.DataAccess.Opf(FN.COM.TYPE, F.COM.TYPE)
    EB.DataAccess.Opf(FN.TAX, F.TAX)
RETURN
*-----------OPENFILE END-------------
*-----------PROCESS START-------------
PROCESS:
    IF Y.RESTRICTIONS EQ '' THEN
        EB.DataAccess.FRead(FN.COM.TYPE, Y.COM.CODE, R.COM.TYPE, F.COM.TYPE, ERR.COM.TYPE)
        Y.UPTO.AMT = R.COM.TYPE<CG.ChargeConfig.FtCommissionType.FtFouUptoAmt>
        Y.MIN.AMT = R.COM.TYPE<CG.ChargeConfig.FtCommissionType.FtFouMinimumAmt>
*---------------GETTING VAT RATE-----------------
        Y.TAX.CODE= R.COM.TYPE<CG.ChargeConfig.FtCommissionType.FtFouTaxCode>
*---------SELECTING VAT IDS THAT HAS TAX.CODE:.:ANY DATE AS PER TAX ID FORMAT--------------
        Y.SEL= 'SELECT FBNK.TAX WITH @ID LIKE ':Y.TAX.CODE:'....'
        EB.DataAccess.Readlist(Y.SEL, Y.TAX.IDS, '', Y.NO.TAX.IDS, ERR.TAX.IDS)
*-----------------SORTING AND GETTING THE LATEST TAX ID----------------
        Y.TAX.CODE.ID=SORT(Y.TAX.IDS)<Y.NO.TAX.IDS>
        EB.DataAccess.FRead(FN.TAX, Y.TAX.CODE.ID, R.TAX, F.TAX, ERR.TAX)
        Y.VAT.RATE=R.TAX<CG.ChargeConfig.Tax.EbTaxRate>
*--------------GETTING CHARGE BY BALANCE LEVEL-------------
        CONVERT SM TO VM IN Y.UPTO.AMT
        CONVERT SM TO VM IN Y.MIN.AMT
        Y.NO.CHG= DCOUNT(Y.UPTO.AMT,VM)
        FOR I = 1 TO Y.NO.CHG
            IF Y.BASE.BALANCE LE Y.UPTO.AMT<1,I> THEN
                BREAK
            END
        NEXT I
*--------------SETTING CHG AMT BASED ON BASE BALANCE LEVEL---------
        Y.CHG.AMT = Y.MIN.AMT<1,I>
*------------------CHECKING IF APPLIED CHARGE IS HALF OR QUARTER--------------
        IF Y.APPLIED.CHG EQ 'HALF' THEN
            Y.CHG.AMT = Y.CHG.AMT/2
        END
        ELSE IF Y.APPLIED.CHG EQ 'QUARTER' THEN
            Y.CHG.AMT = Y.CHG.AMT/4
        END
*---------------------CALCULATING THE CHG VAT AMT-------------
        Y.VAT.AMT = Y.CHG.AMT*(Y.VAT.RATE/100)
        Y.TOTAL.CHG = Y.CHG.AMT+Y.VAT.AMT
*------------------GETTING WORKING BALANCE----------------------
        R.ACC=AC.AccountOpening.Account.Read(Y.ACCOUNTNO, Error)
        Y.ACC.WORKBAL=R.ACC<AC.AccountOpening.Account.WorkingBalance>
*-----------CHECKING IF BALANCE IS LESS THAN TOTAL CHARGE-------------
        IF Y.ACC.WORKBAL GT Y.TOTAL.CHG THEN
            Y.REL.CHG=Y.CHG.AMT
            Y.REL.VAT=Y.VAT.AMT
            Y.DUE.AMT=0
            Y.DUE.VAT=0
            RETURN
        END
*------------CHECKING IF PARTIAL ALLOWED OR THE WORKING BALANCE IS LESS THAN THRESHOLD CHG-------
        IF Y.PARITAL.FLAG EQ 'NO' OR Y.ACC.WORKBAL LT Y.THRESHOLD.CHG THEN
            Y.REL.CHG=0
            Y.REL.VAT=0
            Y.DUE.AMT=Y.CHG.AMT
            Y.DUE.VAT=Y.VAT.AMT
            RETURN
        END
        ELSE
*-----------------CALCULATING REALISE AMT, VAT AND DUE AMT, VAT------------------
            Y.TMP.CHG=Y.ACC.WORKBAL/(1+(Y.VAT.RATE/100))
            Y.REL.CHG= FIELD(Y.TMP.CHG,'.',1)+FIELD(Y.TMP.CHG,'.',2)[1,2]/100
            Y.REL.VAT= Y.REL.CHG*(Y.VAT.RATE/100)
            Y.DUE.AMT= Y.CHG.AMT - Y.REL.CHG
            Y.DUE.VAT= Y.VAT.AMT - Y.REL.VAT
            RETURN
        END
    END
    ELSE
*-------------------IF RESTRICTION EXITS THEN NO CALCULATION AMT, VAT----------------
        Y.CHG.AMT=0
        Y.VAT.AMT=0
        Y.REL.CHG=0
        Y.REL.VAT=0
        Y.DUE.AMT=0
        Y.DUE.VAT=0
    END
RETURN
